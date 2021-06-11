/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_putendl_fd.c                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: meassas <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2016/11/13 21:50:47 by meassas           #+#    #+#             */
/*   Updated: 2017/04/11 17:11:47 by meassas          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

void	ft_putendl_fd(char const *s, int fd)
{
	char *s1;

	s1 = (char*)s;
	if (!s)
		return ;
	if (*s)
	{
		ft_putstr_fd(s1++, fd);
		ft_putchar_fd('\n', fd);
	}
}
