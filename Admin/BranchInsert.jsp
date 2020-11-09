<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Branch Insert | Modern-Gyan</title>

    <link rel="stylesheet" href="BranchInsert.css">
    <link href="https://fonts.googleapis.com/css2?family=Merienda&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Monoton&display=swap" rel="stylesheet">
    <script src="https://kit.fontawesome.com/c99db268c1.js" crossorigin="anonymous"></script>

    <script>
        function DisableSubmit()
        {
            document.getElementById("btAddBranch").disabled="disabled";
            document.getElementById("btAddBranch").style.cursor="not-allowed";

            document.getElementById("br_code").focus();
        }

        function EnableSubmit()
        {
            if(document.getElementById("br_name").value!="" && document.getElementById("br_code").value!="")
            {
                document.getElementById("btAddBranch").disabled="";
                document.getElementById("btAddBranch").style.cursor="pointer";
            }
        }
    </script>
</head>
<body onload="DisableSubmit()">

    <%-- Site Header --%>
    <jsp:include page="AdminSiteHeader.jsp"/>

    <%-- Branch Insert Panel --%>
    <div id="BranchInsertPanel">
        <h4 id="WorkHead">Insert Branch</h4>
        <form action="BranchInsertBack.jsp">
            <table>
                <tr>
                    <th><label for="br_code">Branch Code</label></th><td class="colon">:</td>
                    <td><input type="text" name="txBranchCode" id="br_code" onchange="EnableSubmit()"></td>
                </tr>
                <tr>
                    <th><label for="br_name">Branch Name</label></th><td class="colon">:</td>
                    <td><input type="text" name="txBranchName" id="br_name" onchange="EnableSubmit()"></td>
                </tr>
            </table>
            <div id="BranchAddBtn"><input type="submit" id="btAddBranch" value="Add Branch"> </div>
        </form>
    </div>

    <%-- Success Message --%>
    <div id="SuccessMessage"> <label id="lbMessage">  </label> </div>
    <%
        if((String) application.getAttribute("status") != null)
        {
            %><script> 
                document.getElementById("lbMessage").style.visibility="visible"; 
                document.getElementById("lbMessage").innerHTML = "Branch added successfully <i class='fas fa-check'></i>";
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