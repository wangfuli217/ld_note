/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strnequ.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: meassas <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2016/11/13 18:48:47 by meassas           #+#    #+#             */
/*   Updated: 2016/11/20 21:05:16 by meassas          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

int					ft_strnequ(char const *s1, char const *s2, size_t n)
{
	unsigned char	*cps1;
	unsigned char	*cps2;
	int				i;

	cps1 = (unsigned char*)s1;
	cps2 = (unsigned char*)s2;
	i = 0;
	if ((!s1 && !s2) || (!s1 || !s2))
		return (0);
	while (cps1[i] && cps2[i] && (size_t)i < n)
	{
		if (cps1[i] != cps2[i])
			return (0);
		i++;
	}
	return (1);
}
