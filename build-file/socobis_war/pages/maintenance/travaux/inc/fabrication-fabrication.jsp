<%@ page import="affichage.*" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="maintenance.travaux.TravauxCpl" %>
<%@ page import="maintenance.travaux.OrdreTravaux" %>


<%
    try{
        TravauxCpl t = new TravauxCpl();
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id", "lanceparLib", "remarque", "libelle", "daty"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));

        OrdreTravaux o = new OrdreTravaux();
        o.setId(request.getParameter("id"));

        String[] colSomme = null;
        //pr.setNpp(10);
        pr.creerObjetPage(libEntete, colSomme);

        Map<String,String> lienTab=new HashMap();
        lienTab.put("Valider",pr.getLien() + "?but=apresTarif.jsp&acte=valider&bute=maintenance/travaux/Travaux-fiche.jsp&classe=maintenance.travaux.Travaux&nomtable=TRAVAUX");
        pr.getTableau().setLienClicDroite(lienTab);

        pr.getTableau().setData(o.getTravaux(null,null));
        pr.getTableau().transformerDataString();
%>

<div class="box-body">
    <%
        String lienTableau[] = {pr.getLien() + "?but=maintenance/travaux/Travaux-fiche.jsp"};
        String colonneLien[] = {"id"};
        String[] attributLien = {"id"};
        String colonneModal[] = {"id"};
        pr.getTableau().setAttLien(attributLien);
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setAttLien(attributLien);
        pr.getTableau().setModalOnClick(true,colonneModal);
        String libEnteteAffiche[] = {"ID", "Entit&eacute;", "Remarque", "D&eacute;signation", "Date"};
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
