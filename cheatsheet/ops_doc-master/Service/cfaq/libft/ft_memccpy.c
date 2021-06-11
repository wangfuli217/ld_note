/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_memccpy.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: meassas <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2016/11/09 17:33:29 by meassas           #+#    #+#             */
/*   Updated: 2016/11/20 20:45:14 by meassas          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

void	*ft_memccpy(void *dst, const void *src, int c, size_t n)
{
	while (n--)
	{
		if (*(unsigned char*)src == (unsigned char)c)
		{
			*(unsigned char*)dst++ = *(unsigned char*)src++;
			return (dst);
		}
		*(unsigned char*)dst++ = *(unsigned char*)src++;
	}
	return (NULL);
}
