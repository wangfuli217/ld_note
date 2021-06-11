/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_lstmap.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: meassas <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2016/11/19 13:31:22 by meassas           #+#    #+#             */
/*   Updated: 2016/11/25 16:46:06 by meassas          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

static size_t		lstlenmap(t_list *lst)
{
	size_t			len;
	t_list			*lst2;

	lst2 = lst;
	len = 0;
	while (lst2 != NULL && len++)
		lst2 = lst2->next;
	return (len);
}

t_list				*ft_lstmap(t_list *lst, t_list *(*f) (t_list *elem))
{
	t_list			*new;

	if (!(new = (t_list*)malloc(lstlenmap(lst) * sizeof(t_list))))
		return (NULL);
	if (lst != NULL)
	{
		new = f(lst);
		new->next = ft_lstmap(lst->next, f);
		return (new);
	}
	return (NULL);
}
