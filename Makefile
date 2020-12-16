##
## EPITECH PROJECT, 2020
## Makefile
## File description:
## Makefile
##

NAME	=	funEvalExpr

all:
	make $(NAME)

$(NAME):
	stack build --copy-bins --local-bin-path .
	mv evalExpr-exe funEvalExpr

clean :
	cd evalExpr ; stack clean
	rm -rf funEvalExpr

fclean: clean

re: fclean all

.PHONY:	all clean fclean re $(NAME)
