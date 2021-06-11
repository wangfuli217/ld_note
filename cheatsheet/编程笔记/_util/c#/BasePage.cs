using System;
using System.Web;

namespace Com.Everunion.Util
{
    public class BasePage : System.Web.UI.Page 
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            ChkAdminLogin();
        }

        protected void ChkAdminLogin()
        {
            if (!StringUtil.Requied(SessionUtil.GetMemId(Session)))
            {
                Response.Redirect("~/relogin.html"); 
                return;
            }
        }
    }
}
