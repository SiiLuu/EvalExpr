--
-- EPITECH PROJECT, 2020
-- evalExpr
-- File description:
-- main
--

module Main where

import System.Environment ( getArgs )
import Control.Applicative ( Alternative(empty, (<|>)) )
import System.Exit ( ExitCode(ExitFailure), exitWith )
import Text.Printf (printf)
import Control.Applicative (some)
import Data.Maybe ( fromMaybe )
import Text.Read ()

-- WIKIPEDIA MODEL for implementing the PEG.
-- Expr    ← Sum
-- Sum     ← Product (('+' / '-') Product)*
-- Product ← Power (('*' / '/') Power)*
-- Power   ← Value ('^' Power)?
-- Value   ← [0-9]+ / '(' Expr ')'

-- Create datas for sort our initial string to expression (AST).
data Expr = Add Expr Expr
    | Sub Expr Expr
    | Mul Expr Expr
    | Div Expr Expr
    | Pow Expr Expr
    | Lit Double
    deriving (Show)

-- Fonction for calculate our final expression to an Double nbumber.
eval :: Expr -> Double
eval e = case e of
    Add a b -> eval a + eval b
    Sub a b -> eval a - eval b
    Mul a b -> eval a * eval b
    Div a b -> eval a / eval b
    Pow a b -> eval a ** eval b
    Lit n -> n

-- Our parser data type
data Parser a = Parser {
    runParser :: String -> Maybe (a, String)
}

-- Functor instance (<$>) for apply a function to the result of a parser if he succes (Return Nothing otherwise).
instance Functor Parser where
    fmap fct parser = Parser $ \str -> case runParser parser str of
        Just (a, str) -> Just (fct a, str)
        Nothing -> Nothing

-- Applicative instance
-- (pure) do a simple parser
-- (<*>) if the first parser success we produce a function and a rest and then we do the second parser if he succes too we apply the function to the result.
-- (*>) Sequence actions, discarding the value of the first argument.
-- (<*) Sequence actions, discarding the value of the second argument.
instance Applicative Parser where
    pure a = Parser $ \str -> Just (a, str)
    p1 <*> p2 = Parser $ \str -> case runParser p1 str of
        Just (fct, str) -> case runParser p2 str of
            Just (a, str) -> Just (fct a, str)
            Nothing -> Nothing
        Nothing -> Nothing

-- Functor instance (<|>) do the first parser and if he fail do the second parser.
instance Alternative Parser where
    empty = Parser $ const Nothing
    p1 <|> p2 = Parser $ \str -> runParser p1 str <|> runParser p2 str

-- Display the error message and exit with 84 errorCode.
displayExitMessage :: IO ()
displayExitMessage = putStrLn "USAGE: ./funEvalExpr eval" >>
        putStrLn "\teval\tthe calcul" >>
        exitWith (ExitFailure 84)

-- Parser for parse the first char in the string if the first char is equal its removed form the string otherwise it return Nothing.
parseChar :: Char -> Parser Char
parseChar ch = Parser $ \str-> case str of
    [] -> Nothing
    _ -> if ch == (head str)
            then Just (ch, (tail str))
            else Nothing

-- Parser for parse the first char in the string if the first char is equal its removed form the string otherwise it return Nothing and this since its fails.
parseAnyChar :: String -> Parser Char
parseAnyChar s1 = Parser $ \str -> case str of
    [] -> Nothing
    _ -> if (head str) `elem` s1
            then Just ((head str), (tail str))
            else Nothing

-- Parser for parse the first char in the string if the first char is equal to a number or a point its removed form the string otherwise it return Nothing.
parseDouble :: Parser Double
parseDouble = read <$> some (parseAnyChar "0123456789.")

-- Parser for parse the first char in the string if the first char is equal to a number or a point or a '-' its removed form the string otherwise it return Nothing.
parseDoubleNeg :: Parser Double
parseDoubleNeg = read <$> some (parseAnyChar "0123456789.-")

-- This parser do a parser and check if the result string is empty, if not it return Nothing.
doSimpleParser :: Parser a -> String -> Maybe a
doSimpleParser parser str = case runParser parser str of
    Just (a, "") -> Just a
    _ -> Nothing

-- This function handle the priority of calculs and then give an expression line.
doExpr :: Parser Expr
doExpr = addsub
    where
        addsub = Add <$> muldiv <*> (parseChar '+' *> muldiv) <|> Sub <$> muldiv <*> (parseChar '-' *> muldiv) <|> muldiv
        muldiv = Mul <$> pow <*> (parseChar '*' *> pow) <|> Div <$> pow <*> (parseChar '/' *> pow) <|> pow
        pow = Pow <$> factor <*> (parseChar '^' *> factor) <|> factor
        factor = parenthesis <|> lit
        parenthesis = parseChar '(' *> doExpr <* parseChar ')'
        lit = Lit <$> (parseDouble <|> parseDoubleNeg)

-- This function
-- check if the parser return Nothing (exit 84)
-- check if the result of the expression is Infinite
-- otherwise display the result with .00
checkExp :: Maybe Expr -> IO ()
checkExp Nothing = displayExitMessage
checkExp value = case isInfinite (eval $ fromMaybe (Lit 0.00) value) of
    True -> displayExitMessage
    False -> printf "%0.2f\n" (eval $ fromMaybe (Lit 0.00) value)

-- This fucntion is the main function where we check the argument line of the program and launch our algorythm with the string.
workCenter :: [String] -> IO ()
workCenter args | (length (args !! 0)) == 1 && (head (args !! 0)) == '-' = displayExitMessage
workCenter args | ((length args) == 1) = checkExp (doSimpleParser doExpr $ concat $ words (args !! 0))
workCenter _ = displayExitMessage

-- Main fucntion.
main :: IO ()
main = do
    args <- getArgs
    workCenter args
