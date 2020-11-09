<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Add Admin | Modern-Gyan</title>

    <link rel="stylesheet" href="AddAdmin.css">
    <link href="https://fonts.googleapis.com/css2?family=Merienda&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Monoton&display=swap" rel="stylesheet">
    <script src="https://kit.fontawesome.com/c99db268c1.js" crossorigin="anonymous"></script>

    <script>
        function DisableSubmit()
        {
            document.getElementById("btRegister").disabled="disabled";
            document.getElementById("btRegister").style.cursor="not-allowed";

            document.getElementById("name").focus();
        }

        function EnableSubmit()
        {
            if(document.getElementById("name").value!="" && document.getElementById("user").value!="" &&
            document.getElementById("password").value!="")
            {
                document.getElementById("btRegister").disabled="";
                document.getElementById("btRegister").style.cursor="pointer";
            }
        }
    </script>
</head>
<body onload="DisableSubmit()">

    <%-- Site Header --%>
    <jsp:include page="AdminSiteHeader.jsp"/>

    <!-- Admin add form -->
    <div id="AddAdminPanel">
        <h4 id="WorkHead"> Add Admin </h4>
        <form action="AddAdminBack.jsp" method="POST">
            <table>
                <tr>
                    <th><label for="name">Enter Admin Name</label></th><td class="colon">:</td>
                    <td><input type="text" name="txName" id="name" onchange="EnableSubmit()"></td>
                </tr>
                <tr>
                    <th><label for="user">Enter Admin Id</label></th><td class="colon">:</td>
                    <td><input type="text" name="txUser" id="user" onchange="EnableSubmit()"></td>
                </tr>
                <tr>
                    <th><label for="password">Enter Password</label></th><td class="colon">:</td>
                    <td><input type="password" name="txPassword" id="password" min="4" onchange="EnableSubmit()"></td>
                </tr>
            </table>
            <div id="RegisterBtn"> <input type="submit" id="btRegister" value="Register"> </div>
        </form>
    </div>

    <%-- Success Message --%>
    <div id="SuccessMessage"> <label id="lbMessage">  </label> </div>
    <%
        if((String) application.getAttribute("status") != null)
        {
            %><script> 
                document.getElementById("lbMessage").style.visibility="visible"; 
                document.getElementById("lbMessage").innerHTML = "Admin added successfully <i class='fas fa-check'></i>";
                window.setTimeout('document.getElementById("lbMessage").style.opacity="0"; document.getElementById("lbMessage").style.visibility="hidden";',4000);
            </script><%
        }

        else
        {
            %><script> 
                document.getElementById("lbMessage").style.visibility="hidden"; 
                document.getElementById("lbMessage").innerHTML = "";
            </script><%
        }

        application.removeAttribute("status");
    %>

</body>
</html>