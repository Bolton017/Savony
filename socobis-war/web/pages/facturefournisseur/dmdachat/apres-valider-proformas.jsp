<%--
  Created by IntelliJ IDEA.
  User: Chan Alex
  Date: 26/01/2026
  Time: 17:32
  To change this template use File | Settings | File Templates.
--%>
<%@page import="utils.ConstanteEtatStation"%>
<%@page import="bean.CGenUtil"%>
<%@page import="faturefournisseur.*"%>
<%@page import="user.UserEJB"%>
<%@page import="user.UserEJBBean"%>
<%@page import="utilitaire.UtilDB"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@ page import="faturefournisseur.LiaisonIntraTable" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    try{
        UserEJB u = (UserEJB)session.getAttribute("u");
        String lien = (String)session.getAttribute("lien");
        String bute = request.getParameter("bute");
        String idDmdAchat=request.getParameter("iddmdachat");
        System.out.println("iddmdachat===>"+idDmdAchat);

        DmdAchat dmdAchat = null;
        DmdAchat[] dmdAchats = (DmdAchat[]) CGenUtil.rechercher(new DmdAchat(), null,null, " AND id='"+idDmdAchat+"'");
        if (dmdAchats.length > 0){
            dmdAchat = dmdAchats[0];
        } else {
            throw new Exception("Demande d'achat introuvable");
        }
        dmdAchat.validerProformas(u.getUser());
%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=idDmdAchat%>");</script>
<%
}catch (Exception e) {
    e.printStackTrace();
%>

<script language="JavaScript">
    alert('<%=e.getMessage()%>');
    history.back();
</script>
<%

    }
%>

