<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="caisse.MvtCaisseCpl" %>

<% try{ 
    MvtCaisseCpl o = new MvtCaisseCpl();
    o.setNomTable("MOUVEMENTCAISSECPL");
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"id","idCaisseLib","idModePaiementLib","debit","credit","daty","etatLib","soldecredit","soldedebit"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
        pr.setAWhere(" and idReport='"+request.getParameter("id")+"'");
    }
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    pr.getTableau().setLien(new String[] {pr.getLien() + "?but=caisse/mvt/mvtCaisse-fiche.jsp"});
    pr.getTableau().setColonneLien(new String[]{"id"});
    String[] libEnteteAffiche = {"Ref.","Tr&eacute;sorerie","Mode de paiement","Sortie de tr&eacute;sorerie","Entr&eacute;e de tr&eacute;sorerie","Date","&Eacute;tat","Solde cr&eacute;dit","Solde d&eacute;bit"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>

<div class="box-body">
    <%  if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
        } else{ %>
            <center><h4>Aucune donn&eacute;e trouv&eacute;e</h4></center>
    <%  } %>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

