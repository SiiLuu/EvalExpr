--
-- EPITECH PROJECT, 2020
-- evalExpr
-- File description:
-- errorHandling
--

module ErrorHandling
    ( displayExitMessage
    ) where

import System.Exit
import Text.Read
import Data.Maybe (fromMaybe)

displayExitMessage :: IO ()
displayExitMessage = putStrLn "USAGE: ./funEvalExpr eval" >>
        putStrLn "\teval\tthe calcul" >>
        exitWith (ExitFailure 84)