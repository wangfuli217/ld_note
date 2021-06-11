/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strsplit.c                                      :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: meassas <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2016/11/19 15:51:36 by meassas           #+#    #+#             */
/*   Updated: 2016/11/20 21:02:59 by meassas          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

static	int		countwrd(char *s, char c)
{
	int			i;
	int			j;

	i = 0;
	j = 0;
	if (!s)
		return (0);
	while (s[i])
	{
		if (s[i] != c && (s[i + 1] == c || s[i + 1] == '\0'))
			j++;
		i++;
	}
	return (j);
}

char			**ft_strsplit(char const *s, char c)
{
	int			i;
	int			y;
	char		**split;
	int			end;

	i = 0;
	y = 0;
	end = 0;
	if (!(split = (char**)malloc(sizeof(char*) * (countwrd((char*)s, c)) + 1))
			|| (!s))
		return (NULL);
	while (y < countwrd((char*)s, c) && s[i])
	{
		while (s[i] == c)
			i++;
		end = i;
		while (s[end] != c && s[end])
			end++;
		split[y++] = ft_strsub((char*)s, i, end - i);
		i = end;
	}
	split[y] = 0;
	return (split);
}
