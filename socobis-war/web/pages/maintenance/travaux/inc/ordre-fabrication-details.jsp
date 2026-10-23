<%@page import="fabrication.*"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="produits.Ingredients" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="historique.MapUtilisateur" %>


<%
    try{
        OfFilleCpl t = new OfFilleCpl();
        t.setNomTable("OTRAVFILLELIBSTOCK");
        String listeCrt[] = {};
        String listeInt[] = {};
        UserEJB user = (user.UserEJB) session.getValue("u");
        MapUtilisateur mapUser = user.getUser();
        String libEntete[] = new String[]{"id", "idingredients", "libelleexacte","remarque"};
//        if(mapUser.getIdrole().equals(ConstanteSocobis.CHEFFABR_RANG) || mapUser.getIdrole().equals(ConstanteSocobis.DG_RANG)) {
//            libEntete = new String[]{"id", "idingredients", "idunite", "libelleexacte","purevient","qte","qtefabrique","qtereste","pv","montantRevient","montantentree","montantsortie","tauxrevient"};
//        }
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));

        if(request.getParameter("id") != null){
            pr.setAWhere(" and idMere='"+request.getParameter("id")+"'");
        }
        String[] colSomme = null;
        //pr.setNpp(10);
        pr.creerObjetPage(libEntete, colSomme);
        OfFille[] listeFille=(OfFille[]) pr.getTableau().getData();
//        if(listeFille.length>0) {
//            Of o = new Of();
//            o.setFille(listeFille);
//            o.calculerRevient(null);
//        }

        String lienTableau[] = {pr.getLien() + "?but=maintenance/travaux/Otravaux-details-fiche.jsp", pr.getLien() + "?but=maintenance/ressources/machine/machine-fiche.jsp"};
        String colonneLien[] = {"id", "idingredients"};
        String[] attributLien = {"id", "id"};
        String colonneModal[] = {"id","idingredients"};
        pr.getTableau().setAttLien(attributLien);
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setAttLien(attributLien);
//        pr.getTableau().setModalOnClick(true,colonneModal);
        Map<String,String> lienTab=new HashMap();
        lienTab.put("Ex&eacute;cuter-idOffille",pr.getLien() + "?but=maintenance/travaux/Travaux-saisie.jsp");
//        lienTab.put("Fabriquer un par un-idOffille",pr.getLien() + "?but=fabrication/fabrication-saisie.jsp&unParUn=true");
//        lienTab.put("Situation globale",pr.getLien() + "?but=fabrication/offille-situation-globale.jsp");
        pr.getTableau().setLienClicDroite(lienTab);

        pr.getTableau().setLienFille("maintenance/travaux/inc/liste-fabrication-of.jsp&id=");
        //pr.getTableau().setData(listeFille);
        pr.getTableau().transformerDataString();


%>

<div class="box-body">
    <%
        String libEnteteAffiche[] = new String[]{"id", "ID Machine","Machine","Remarque"};
//        if(mapUser.getIdrole().equals(ConstanteSocobis.CHEFFABR_RANG) || mapUser.getIdrole().equals(ConstanteSocobis.DG_RANG)) {
//            libEnteteAffiche = new String[]{"id", "Composants", "Unit&eacute;","D&eacute;signation","PU de revient","Qt&eacute; Ordre","Qt&eacute; Fabriqu&eacute;","Qt&eacute; restante","Prix de vente","Montant Th&eacute;orique","Valeur Fabriqu&eacute;e","D&eacute;pense de Fabrication","Taux de revient ( en %)"};
//        }
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

