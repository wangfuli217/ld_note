using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using Barfoo.Library.Serialization;

namespace Barfoo.Library.Web.MVC
{
    public class JsonModelBinder<T> : DefaultModelBinder
    {

        public override object BindModel(ControllerContext controllerContext, ModelBindingContext bindingContext)
        {
            string jsonStr = string.Empty;
            if (controllerContext.HttpContext.Request.Form[bindingContext.ModelName] != null)
            {
                jsonStr = controllerContext.HttpContext.Request.Form[bindingContext.ModelName] as string;
            }
            else if (controllerContext.HttpContext.Request.QueryString[bindingContext.ModelName] != null)
            {
                jsonStr = controllerContext.HttpContext.Request.QueryString[bindingContext.ModelName] as string;
            }
            try
            {
                if (jsonStr.StartsWith("{") && jsonStr.EndsWith("}"))
                {
                    return jsonStr.FromJson<T>();
                }
                if (jsonStr.StartsWith("[") && jsonStr.EndsWith("]"))
                {
                    return jsonStr.FromJson<List<T>>();
                }
            }
            catch (Exception)
            {
               return base.BindModel(controllerContext, bindingContext);
            }
            return null;
        }
    }
}
