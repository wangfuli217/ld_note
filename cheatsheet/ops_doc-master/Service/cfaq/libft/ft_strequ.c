/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strequ.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: meassas <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2016/11/13 18:33:23 by meassas           #+#    #+#             */
/*   Updated: 2016/11/21 14:52:27 by meassas          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

int					ft_strequ(char const *s1, char const *s2)
{
	int				i;
	unsigned char	*cps1;
	unsigned char	*cps2;

	cps1 = (unsigned char*)s1;
	cps2 = (unsigned char*)s2;
	i = 0;
	if ((!s1 && !s2) || (!s1 || !s2))
		return (0);
	while (cps1[i] || cps2[i])
	{
		if (cps1[i] != cps2[i])
			return (0);
		i++;
	}
	return (1);
}
