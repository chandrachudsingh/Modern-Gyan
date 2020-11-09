<!-- Header Panel -->
<header>
    <form action="FacultyProfile.jsp" id="ProfileBtn"> <button type="submit" name="btHome"> <i class="fas fa-user-circle"></i> </button> </form>
    <span id="greeting">Hi ${applicationScope.session_faculty}</span>
    <span id="SiteName" title="Modern-Gyan"> Modern-Gyan </span>
    <form action="../LogoutPage.jsp" id="LogoutBtn"> <input type="submit" name="btLogout" value="logout"> </form>
</header>