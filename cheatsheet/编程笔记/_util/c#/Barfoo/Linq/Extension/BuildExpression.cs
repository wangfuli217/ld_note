using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Linq.Expressions;

namespace Barfoo.Library.Linq
{
	public static class BuildExpression
	{
        private static Expression<Func<TElement, bool>> BuildWhereInExpression<TElement, TValue>(Expression<Func<TElement, TValue>> propertySelector, IEnumerable<TValue> values)
        {
            ParameterExpression p = propertySelector.Parameters.Single();
            if (!values.Any())
                return e => false;

            var equals = values.Select(value => (Expression)Expression.Equal(propertySelector.Body, Expression.Constant(value, typeof(TValue))));
            var body = equals.Aggregate<Expression>((accumulate, equal) => Expression.Or(accumulate, equal));

            return Expression.Lambda<Func<TElement, bool>>(body, p);
        }
		public static IQueryable<TElement> WhereIn<TElement, TValue>(this IQueryable<TElement> source, Expression<Func<TElement, TValue>> propertySelector, params TValue[] values)
		{
			return source.Where(BuildWhereInExpression(propertySelector, values));
		}


        #region Where Not In

        private static Expression<Func<TElement, bool>>
            GetWhereNotInExpression<TElement, TValue>(
            Expression<Func<TElement, TValue>> propertySelector,
            IEnumerable<TValue> values)
        {
            ParameterExpression p =
                propertySelector.Parameters.Single();

            if (!values.Any())
            {
                return e => true;
            }

            var unequals = values.Select(value =>
                (Expression)Expression.NotEqual(
                    propertySelector.Body,
                    Expression.Constant(value, typeof(TValue))
                )
            );

            var body = unequals.Aggregate<Expression>(
                (accumulate, unequal) => Expression.And(accumulate, unequal));

            return Expression.Lambda<Func<TElement, bool>>(body, p);
        }

        public static IQueryable<TElement>
            WhereNotIn<TElement, TValue>(this IQueryable<TElement> source,
            Expression<Func<TElement, TValue>> propertySelector,
            params TValue[] values)
        {
            return source.Where(GetWhereNotInExpression(
                propertySelector, values));
        }

        public static IQueryable<TElement>
            WhereNotIn<TElement, TValue>(this IQueryable<TElement> source,
            Expression<Func<TElement, TValue>> propertySelector,
            IEnumerable<TValue> values)
        {
            return source.Where(GetWhereNotInExpression(
                propertySelector, values));
        }

        #endregion


	}
}
