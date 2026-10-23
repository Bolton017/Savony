<%--
  Created by IntelliJ IDEA.
  User: safidy
  Date: 05/08/2025
  Time: 14:02
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="affichage.PageRecherche" %>
<%@page import="affichage.*"%>
<%@ page import="client.ReleveClient" %>
<%  try{

    ReleveClient dmd = new ReleveClient();
    dmd.setNomTable("releveclient");
    String listCrt[] = {"id", "daty", "journal", "reference", "clientlib", "libelle", "lettre","debit","credit"};
    String listInt[] = {"daty"};
    String libEntete[] = {"id", "daty", "journal", "reference", "clientlib", "libelle", "lettre","debit","credit"};

    PageRecherche pr = new PageRecherche(dmd, request, listCrt, listInt, 3,libEntete, libEntete.length);
    pr.setTitre("RELEVE CLIENT");
    if(request.getParameter("id") != null){
        pr.setAWhere(" and idClient='"+request.getParameter("id")+"'");
    }
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("vente/releve-client.jsp");

    pr.getFormu().getChamp("debit").setLibelle("D&eacute;bit");
    pr.getFormu().getChamp("credit").setLibelle("Cr&eacute;dit");
    pr.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("clientlib").setLibelle("Client");

    String[] colSomme = { "debit", "credit", "solde" };
    String[] enteteRecap = {"","Nombre","Somme des debits","Somme des credits", "Solde"};
    pr.creerObjetPage(libEntete, colSomme);


    String lienTableau[] = {pr.getLien() + "?but=vente/vente-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableauRecap().setLibeEntete(enteteRecap);
    String[] attributLien = {"id"};
    pr.getTableau().setAttLien(attributLien);

    String libEnteteAffiche[] = {"id", "Date", "Journal", "R&eacute;f&eacute;rence", "Client", "Libell&eacute;", "Lettre","D&eacute;bit","Cr&eacute;dit"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>
<div class="box-body">
    <%
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
        }else
        {
    %><center><h4>Aucune donne trouvé</h4></center><%
    }


%>
</div><%
    }catch(Exception e){
        e.printStackTrace();
    }
%>


