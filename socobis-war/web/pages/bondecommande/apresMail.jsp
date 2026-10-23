<%@page import="user.UserEJB"%>
<%@ page import="faturefournisseur.SendMail" %>
<%@ page import="faturefournisseur.As_BonDeCommande" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    try{
        String lien = (String)session.getAttribute("lien");
        String acte = request.getParameter("acte");
        String bute = "bondecommande/bondecommande-fiche.jsp";
        String id = request.getParameter("id");

        SendMail sendMail = new SendMail();
        As_BonDeCommande asBonDeCommande = (As_BonDeCommande) new As_BonDeCommande().getById(id, "AS_BONDECOMMANDE", null);
        sendMail.sendMail("Rappel – Bon de commande en attente de validation", sendMail.prepareContenuMailDG(asBonDeCommande), "tsinjoniaina.randriamirado@gmail.com", null);

%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=id%>");</script>
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
