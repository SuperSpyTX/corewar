/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   file_op.c                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: asarandi <asarandi@student.42.us.org>      +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2018/01/28 17:29:57 by asarandi          #+#    #+#             */
/*   Updated: 2018/02/11 22:03:28 by asarandi         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "asm.h"

void	gfc_quit(int errnum, void *memory)
{
	if (memory != NULL)
		free(memory);
	ft_printf("%s\n", strerror(errnum));
	exit(EXIT_FAILURE);
}

ssize_t	getfilesize(char *filename)
{
	int		fd;
	ssize_t	size;
	int		r;
	char	buf;

	if ((fd = open(filename, O_RDONLY)) == -1)
		return (-1);
	size = 0;
	while ((r = read(fd, &buf, 1)) == 1)
		size++;
	close(fd);
	if (r == 0)
		return (size);
	else
		return (-1);
}

void	*getfilecontents(char *filename, size_t *size)
{
	ssize_t			r;
	int				fd;
	unsigned char	*mem;

	if ((int)(*size = getfilesize(filename)) == -1)
		gfc_quit(errno, NULL);
	if ((mem = ft_memalloc(*size + 1)) == NULL)
		gfc_quit(errno, NULL);
	if ((fd = open(filename, O_RDONLY)))
	{
		r = read(fd, mem, *size);
		close(fd);
		if (r == (ssize_t)*size)
			return (mem);
	}
	free(mem);
	gfc_quit(errno, NULL);
	return (NULL);
}

int		put_file_contents(char *filename, unsigned char *data, size_t size)
{
	int		fd;

	if ((fd = open(filename, O_CREAT | O_WRONLY | O_TRUNC, 0644)) == -1)
		return (0);
	if ((write(fd, data, size)) == -1)
	{
		close(fd);
		return (0);
	}
	close(fd);
	return (1);
}
