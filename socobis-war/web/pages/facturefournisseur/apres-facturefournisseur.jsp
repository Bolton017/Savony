<%--
  Created by IntelliJ IDEA.
  User: madalitso
  Date: 2025-07-29
  Time: 12:08
  To change this template use File | Settings | File Templates.
--%>
<%--
    Document   : apresLivraisonFacture
    Created on : 5 août 2024, 10:50:05
    Author     : Mirado
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
    String acte = request.getParameter("acte");
    String bute = request.getParameter("bute");
    String type = request.getParameter("type");
    String nomtable=request.getParameter("nomtable");
    String id1=request.getParameter("id1");
    String id2=request.getParameter("id2");
    String montant=request.getParameter("montant");
    String tab = "";
    System.err.println(id1+"==="+id2);
    System.err.println("===>"+acte);

    if (acte.compareToIgnoreCase("insert") == 0) {
      if(id1!=null && id2!=null){
        LiaisonIntraTable liaison = new LiaisonIntraTable();
        liaison.lier(id1,id2,u.getUser().getTuppleID());
        tab="inc/facturefournisseur-lier";
      }
      else{
      throw new Exception("Completer tous les champs");
      }
    }
    if (acte.compareToIgnoreCase("liaison_payementff") == 0) {
      if(id1!=null && id2!=null){
        LiaisonIntraTable liaison = new LiaisonIntraTable();
        liaison.setId1(id1);
        liaison.setId2(id2);
        liaison.setMontant(Double.valueOf(montant));
        liaison.creerPaiementFF(u.getUser().getTuppleID(),null);
        tab="paiementFF-details";
      }
      else{
      throw new Exception("Completer tous les champs");
      }
    }
%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=id1%>&tab=<%=tab%>");</script>
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

