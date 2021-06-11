/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strlcat.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: meassas <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2016/11/08 15:28:50 by meassas           #+#    #+#             */
/*   Updated: 2016/11/23 18:39:27 by meassas          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

size_t		ft_strlcat(char *dst, const char *src, size_t size)
{
	size_t	i;
	size_t	end;
	size_t	j;

	i = 0;
	while (dst[i] && i < size)
		i++;
	end = i;
	j = 0;
	while (src[j] && i < size - 1)
		dst[i++] = src[j++];
	if (end <= size - 1)
		dst[i] = '\0';
	return (end + ft_strlen(src));
}
