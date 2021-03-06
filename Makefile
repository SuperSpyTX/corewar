# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: kyork <marvin@42.fr>                       +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2018/01/19 13:14:58 by kyork             #+#    #+#              #
#*   Updated: 2018/04/11 19:16:07 by jkrause          ###   ########.fr       *#
#    Updated: 2018/02/21 21:44:22 by jkrause          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME 		= corewar

COMMONSRC	+= op.c instr.c string.c

ASM_SRC		+= $(addprefix asm/, char_array.c count.c error.c file_op.c instruction_utils.c instructions.c is_operand.c label_utils.c main.c output.c queue_add.c resolve_labels.c string.c trim.c util.c validate_header.c whitespace.c header_utils.c hexdump.c operand_error.c)

VM_SRC		+= $(addprefix vm/, instr.c op_fork.c op_ldisti.c main.c op_math.c op_jmp.c op_ldst.c memory.c cycle.c champions.c heap.c fork.c)

DISASM_SRC  += disasm/main.c disasm/file_op.c disasm/instruction.c disasm/print.c disasm/stdin.c disasm/util.c

ASM_OBJS	= $(addprefix build/, $(COMMONSRC:.c=.o) $(ASM_SRC:.c=.o))
VM_OBJS		= $(addprefix build/, $(COMMONSRC:.c=.o) $(VM_SRC:.c=.o))
DISASM_OBJS = $(addprefix build/, $(COMMONSRC:.c=.o) $(DISASM_SRC:.c=.o))
LIBS		= libft/libft.a

# Flags start
CFLAGS		+= -Wall -Wextra -Wmissing-prototypes
CFLAGS		+= -I includes/
LDFLAGS		+= -Wall -Wextra

ifndef ALL_ERRORS
	CFLAGS += -ferror-limit=1000000
endif

ifndef NO_WERROR
	CFLAGS += -Werror
	LDFLAGS += -Werror
endif

ifdef DEBUG
	CFLAGS += -fsanitize=address -g
	LDFLAGS += -fsanitize=address -g
endif

ifdef RELEASE
	CFLAGS += -O2
	LDFLAGS += -O2
endif
# Flags end

.PHONY: all clean fclean re

all: corewar asm disasm

corewar: $(VM_OBJS) $(LIBS)
	$(CC) $(LDFLAGS) -o $@ $^

asm: $(ASM_OBJS) $(LIBS)
	$(CC) $(LDFLAGS) -o $@ $^

disasm: $(DISASM_OBJS) $(LIBS)
	$(CC) $(LDFLAGS) -o $@ $^

libft/libft.a: libft
	$(MAKE) -C libft libft.a

clean:
	rm -rf build/
	$(MAKE) -C libft clean

fclean: clean
	rm -f corewar asm
	$(MAKE) -C libft fclean

re: fclean
	$(MAKE) all

build:
	mkdir -p build

build/%.o: src/%.c | build
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c -o $@ $<


