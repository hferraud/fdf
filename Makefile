#*** VARIABLES ***#

NAME			=	fdf

#FILES

SRCS			=	main.c			fdf.c		\
					draw_line.c		draw_map.c	\
					matrices.c		vector.c	\
					keys.c	\
					$(addprefix $(DIR_UTILS), $(UTILS))	\
					$(addprefix $(DIR_GNL), $(GNL))		\
					$(addprefix $(DIR_PARS), $(PARS))	\
					$(addprefix $(DIR_CLIP), $(CLIP))

PARS			=	parser.c	parser_utils.c

CLIP			=	clipping.c

GNL				=	get_next_line.c	get_next_line_utils.c

UTILS			=	ft_iatoi.c		ft_isdigit.c

HEAD			=	fdf.h

OBJS			=	$(SRCS:%.c=$(DIR_OBJS)%.o)

DEPS			= 	$(OBJS:.o=.d)


#DIRECTORIES

DIR_SRCS		=	srcs/

DIR_PARS		=	parser/

DIR_CLIP		=	clipping/

DIR_GNL			=	gnl/

DIR_UTILS		=	utils/

DIR_MLX			=	mlx/

DIR_HEAD		=	includes/

DIR_OBJS		=	.build/

DIR				=	$(DIR_UTILS) $(DIR_GNL) $(DIR_PARS) $(DIR_CLIP)

#ARBORESCENCE

ARB_OBJS		=	$(addprefix $(DIR_OBJS), $(DIR))

#PATH

PATH_HEAD		=	$(addprefix $(DIR_HEAD), $(HEAD))

#COMPIL

CC				=	cc

CFLAGS			=	-Wall -Wextra -Werror -O3

DFLAGS			=	-Wall -Wextra -Werror -g3 -fsanitize=address

DEBUG			=	false

MLXFLAG			=	-Lmlx -lmlx -framework OpenGL -framework Appkit

DEPS_FLAGS		=	-MMD -MP

#COMMANDS

RM				=	rm -rf

MKDIR			=	mkdir -p

LDB				=	lldb

#*** RULES ***#

all				:	$(DIR_OBJS) $(NAME)

run				:	all
					./fdf test_maps/42.fdf

-include		$(DEPS)

$(NAME)			:	$(OBJS)
ifeq ($(DEBUG),true)
	$(CC) $(DFLAGS) $(OBJS) -o $(NAME) $(MLXFLAG)
else
	$(CC) $(CFLAGS) $(OBJS) -o $(NAME) $(MLXFLAG)
endif

debug			:
				$(MAKE) -C . re DEBUG=true
				$(LDB)
				$(MAKE) -C . clean

#COMPIL

$(DIR_OBJS)%.o	:	$(DIR_SRCS)%.c
ifeq ($(DEBUG),true)
	$(CC) $(DFLAGS) $(DEPS_FLAGS) -I$(DIR_HEAD) -c $< -o $@ -I$(DIR_MLX)
else
	$(CC) $(CFLAGS) $(DEPS_FLAGS) -I$(DIR_HEAD) -c $< -o $@ -I$(DIR_MLX)
endif

$(DIR_OBJS)		:
					$(MKDIR) $(ARB_OBJS)

#CLEAN

clean			:
					$(RM) $(DIR_OBJS)

fclean			:	clean
					$(RM) $(NAME)

re				:	
					$(MAKE) -C . fclean
					$(MAKE) -C . all
