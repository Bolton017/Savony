


<%@page import="user.UserEJB"%>
<%@page import="utilitaire.UtilDB"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@ page import="facture.tr.Traite" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    Connection connection = null;
    try{
        UserEJB u = (UserEJB)session.getAttribute("u");
        connection = new UtilDB().GetConn();
        String lien = (String)session.getAttribute("lien");
        String acte = request.getParameter("action");
        String actee = request.getParameter("acte");
        String bute = request.getParameter("bute");
        String type = request.getParameter("type");
        String nomtable=request.getParameter("nomtable");
        String[] tId = request.getParameterValues("ids");

        if(acte.equals("viserTraite")){
            Traite traite=new Traite();
            traite.avantVerser(tId, u.getUser().getTuppleID(), request.getParameter("idcaisse"),request.getParameter("date"), connection);
        }

%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>");</script>
<%
}catch (Exception e) {
    e.printStackTrace();
%>

<script language="JavaScript"> alert("<%=new String(e.getMessage().getBytes(), "UTF-8")%>");
history.back();</script>
<%
        return;
    } finally {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>