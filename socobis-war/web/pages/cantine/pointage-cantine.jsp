<%--
    Document   : pointage-cantine
    Created on : 16 Dec 2025, 15:33
    Author     : NH
--%>

<%@page import="user.UserEJB"%>

<%
    try{
        String titre = "Import Pointage de cantine";
%>
<div class="content-wrapper">
    <h1> <%=titre%> </h1>

    <form action="<%= (String)session.getValue("lien") + "/../../ImportPointageCantineServlet"%>"
              method="post"
              enctype="multipart/form-data">
        <div class="form-group">
            <label for="excelFile">Choisir le fichier .xlsx: </label>
            <input type="file" name="excelFile" id="excelFile" class="form-control" required accept=".xlsx, .xls">
        </div>
        <br>
        <button type="submit" class="btn btn-primary">Importer</button>
    </form>
</div>

<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript">
    alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>