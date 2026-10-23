
<%@page import="bean.CGenUtil"%>
<%@page import="paiement.*"%>
<%@page import="user.UserEJB"%>
<%@page import="user.UserEJBBean"%>
<%@page import="utilitaire.UtilDB"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Date"%>
<%@page import="utilitaire.*"%>
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
    String paiementPar = request.getParameter("paiementPar");
    String[] ids =  request.getParameterValues("ids");
    if (acte.compareToIgnoreCase("paiement_facture") == 0) {
      if(id1!=null && id2!=null){
        LiaisonPaiement pf = new LiaisonPaiement();
        pf.setId1(id1);
        pf.setId2(id2);
        pf.setMontant(Double.valueOf(montant));
        if (paiementPar!=null && paiementPar.compareToIgnoreCase("traite") == 0){
          pf.creerPaiementFactureParTraite(u.getUser().getTuppleID(),null);
        } else {
            System.out.println("Miditra ato");
            System.out.println("id1 === "+id1+"///// id2 === "+id2);
            pf.creerPaiementFacture(u.getUser().getTuppleID(),null);
        }
        tab="paiementFacture-details";
      }
      else{
      throw new Exception("Completer tous les champs");
      }
    }
    if (acte.compareToIgnoreCase("liaisonFactureCaisse") == 0) {
        String ids_vente=request.getParameter("ids_vente");
        String[] tabVente=ids_vente.split(";");
        LiaisonPaiement lp=new LiaisonPaiement();
        lp.creerPaiementParCaisse(ids,tabVente,u.getUser().getTuppleID(),null);
        tab="paiementFacture-details";
    }
%>

<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=id2%>&tab=<%=tab%>");</script>

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

