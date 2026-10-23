<%@page import="utils.ConstanteEtatStation"%>
<%@page import="bean.CGenUtil"%>
<%@page import="vente.BonDeCommande"%>
<%@page import="user.UserEJB"%>
<%@page import="user.UserEJBBean"%>
<%@page import="utilitaire.UtilDB"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
try{
        UserEJB u = (UserEJB)session.getAttribute("u");
        String lien = (String)session.getAttribute("lien");
        String acte = request.getParameter("acte");
        String bute = "vente/bondecommande/bondecommande-fiche.jsp";
        String type = request.getParameter("type");
        String nomtable=request.getParameter("nomtable");
        BonDeCommande v = (BonDeCommande)new BonDeCommande().getById(request.getParameter("id"), "BONDECOMMANDE_CLIENT", null);
        v.updateEtat(u.getUser().getTuppleID(),null,13);
%>
        <script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=request.getParameter("id")%>");</script>
<%
}catch (Exception e) {
        e.printStackTrace();
%>

    <script language="JavaScript"> alert("<%=new String(e.getMessage().getBytes(), "UTF-8")%>");
history.back();</script>
<%
        return;
}
%>
