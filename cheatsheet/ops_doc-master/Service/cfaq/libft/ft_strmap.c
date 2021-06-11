/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strmap.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: meassas <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2016/11/13 18:02:41 by meassas           #+#    #+#             */
/*   Updated: 2016/11/20 21:05:59 by meassas          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

char		*ft_strmap(char const *s, char (*f)(char))
{
	int		i;
	char	*s2;

	s2 = (char*)s;
	i = 0;
	if (!s)
		return (NULL);
	if (!(s2 = (char*)malloc(sizeof(char) * ft_strlen(s) + 1)))
		return (NULL);
	while (s[i])
	{
		s2[i] = f((char)s[i]);
		i++;
	}
	s2[i] = '\0';
	return (s2);
}
