<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Login Page | Modern-Gyan</title>

    <link rel="stylesheet" href="LoginPage.css">
    <link href="https://fonts.googleapis.com/css2?family=Merienda&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Monoton&display=swap" rel="stylesheet">
    <script src="https://kit.fontawesome.com/c99db268c1.js" crossorigin="anonymous"></script>

    <script>
        function ChangeText()
        {

            if(document.getElementById("faculty").checked)
            {
                document.getElementById("user").placeholder = "Enter FacultyId";
                document.getElementById("RegisterLink").href = "Faculty/FacultyRegister.jsp";
            }
            else
            {
                document.getElementById("user").placeholder = "Enter UserId";
                document.getElementById("RegisterLink").href = "Student/StudentRegister.jsp";
            }
        }
    </script>
</head>
<body>
    <span id="SiteName" title="Modern-Gyan"> Modern-Gyan </span>
    <div id="LoginPanel">
        <div id="LoginImage"> <img src="Images/identity-verification-admin.svg" alt=""> </div>
        <div id="LoginFields">
            <i class="fas fa-sign-in-alt"></i>
            <h1>Login/Signup</h1>
            <p>Get a personalised experience, and access all your activities and courses.</p>
            <form action="LoginPageBack.jsp" method="POST">
                <div>
                    <span>
                        <input type="radio" name="rbUserType" id="student" value="Student" onchange="ChangeText()">
                        <label for="student" id="studentlabel">Student</label>
                    </span>
                    <span>
                        <input type="radio" name="rbUserType" id="faculty" value="Faculty" onchange="ChangeText()">
                        <label for="faculty" id="facultylabel">Faculty</label>
                    </span>
                </div>
                <input type="text" name="txUsername" id="user" placeholder="Enter Username">
                <input type="password" name="txPassword" id="password" placeholder="Enter Password" minlength="4">
                <input type="submit" id="btLogin" value="Login">
            </form>
            <p id="SignupLine"> New user ?, <a href="" id="RegisterLink"> Register here </a> </p>
        </div>
    </div>

    <%-- Success Message --%>
    <div id="SuccessMessage"> <label id="lbMessage">  </label> </div>
    <%
        if((String) application.getAttribute("status") != null)
        {
            %><script> 
                document.getElementById("lbMessage").style.visibility="visible"; 
                document.getElementById("lbMessage").style.boxShadow="1px 1px 6px gray"; 
                document.getElementById("lbMessage").innerHTML = "Registration successfull <i class='fa fa-thumbs-up'></i>, login to continue..";
                window.setTimeout('document.getElementById("lbMessage").style.opacity="0"; document.getElementById("lbMessage").style.visibility="hidden";'
                    + ' document.getElementById("lbMessage").style.boxShadow="none";',4000);
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