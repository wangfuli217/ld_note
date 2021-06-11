/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_memchr.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: meassas <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2016/11/10 16:14:25 by meassas           #+#    #+#             */
/*   Updated: 2016/11/20 20:45:41 by meassas          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

void				*ft_memchr(const void *s, int c, size_t n)
{
	unsigned char	*s2;
	unsigned char	sch;

	s2 = (unsigned char*)s;
	sch = (unsigned char)c;
	while (n > 0)
	{
		if (*s2 == sch)
			return ((unsigned char*)s);
		s2++;
		s++;
		n--;
	}
	return (NULL);
}
