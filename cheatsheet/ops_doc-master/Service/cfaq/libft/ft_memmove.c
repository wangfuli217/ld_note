/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_memmove.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: meassas <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2016/11/10 17:08:04 by meassas           #+#    #+#             */
/*   Updated: 2016/11/19 19:19:29 by meassas          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

void				*ft_memmove(void *dst, const void *src, size_t n)
{
	unsigned char	*dst2;
	unsigned char	*src2;

	dst2 = (unsigned char*)dst;
	src2 = (unsigned char*)src;
	if (src2 >= dst2)
	{
		while (n--)
			*dst2++ = *src2++;
		return (dst);
	}
	else
	{
		dst2 += n;
		src2 += n;
		while (n--)
			*--dst2 = *--src2;
		return (dst);
	}
}
