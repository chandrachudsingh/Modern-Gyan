<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title> Logout Page | Modern-Gyan </title>

</head>
<body>

    <%
        if((String) application.getAttribute("session_admin") != null)
        {
            application.removeAttribute("session_admin");
            response.sendRedirect("Admin/AdminLogin.html");
        }

        else
        {
            application.removeAttribute("session_faculty");
            application.removeAttribute("session_student");
            response.sendRedirect("LoginPage.jsp");
        }
    %>

</body>