
<%@ page import="stock.*" %>
<%@ page import="affichage.*" %>
<%@ page import="faturefournisseur.As_BonDeCommandeCpl" %>
<%@ page import="faturefournisseur.FactureFournisseurCpl" %>
<%@ page import="maintenance.travaux.MoTravauxLib" %>
<%@ page import="maintenance.travaux.ProcessMaintenanceLib" %>
<%@ page import="bean.AdminGen" %>
<%@ page import="utils.CalendarUtil" %>
<%@ page import="maintenance.travaux.TravauxRecap" %>


<%
    try{
        TravauxRecap t = new TravauxRecap();
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"montantChargeExterne","montantPiece","montantMainDoeuvre","montantTotal"};
        String libEnteteAffiche[] = {"Montant des charges externes","Montant des pi&egrave;ces","Montant des mains d'oeuvres","Montant Total"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            String idFab = request.getParameter("id");
            pr.setAWhere(" and id='"+idFab+"'");
            pr.setApres("maintenance/travaux/Travaux-fiche.jsp&id="+idFab+"&tab=inc/travaux-recap");
        }
        String[] colSomme = null;
        //pr.setNpp(10);
        pr.creerObjetPage(libEntete, colSomme);
        pr.getTableau().transformerDataString();
//        pr.getTableauRecap().setLibeEntete(new String[]{"","Nombre","Somme des dur&eacute;es estimatives","Montant total"});
//        String lienTableau[] = {pr.getLien() + "?but=facturefournisseur/facturefournisseur-fiche.jsp"};
//        String colonneLien[] = {"id"};
//        pr.getTableau().setLien(lienTableau);
//        pr.getTableau().setColonneLien(colonneLien);
%>

<div class="box-body">
    <%
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
    %>
    <%  }if(pr.getTableau().getHtml() == null)
    {
    %><center><h4>Aucune donne trouvee</h4></center><%
    }


%>
</div>
<%=pr.getModalHtml("modalContent")%>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>

