<%--
    Document   : vente-details
    Created on : 22 mars 2024, 17:05:45
    Author     : Angela
--%>


<%@page import="fabrication.*"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="produits.Ingredients" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="historique.MapUtilisateur" %>
<%@ page import="utils.ConstanteSocobis" %>


<%
    try{
        OfFilleCpl t = new OfFilleCpl();
        t.setNomTable("OfFilleLibStock");
        String listeCrt[] = {};
        String listeInt[] = {};
        UserEJB user = (user.UserEJB) session.getValue("u");
        MapUtilisateur mapUser = user.getUser();
        String libEntete[] = new String[]{"id", "idingredients", "libelleexacte", "remarque", "idunite","qte"};
        if(mapUser.getIdrole().equals(ConstanteSocobis.CHEFFABR_RANG) || mapUser.getIdrole().equals(ConstanteSocobis.DG_RANG)) {
            libEntete = new String[]{"id", "idingredients", "libelleexacte", "remarque", "idunite","pv","purevient","qte","qtefabrique","qtereste","montantRevient","montantentree","montantsortie","tauxrevient"};
        }
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
        if(listeFille.length>0) {
            Of o = new Of();
            o.setFille(listeFille);
            o.calculerRevient(null);
        }
        String lienDetail=pr.getLien() + "?but=fabrication/ordre-fabrication-details-fiche.jsp";
        if(request.getParameter("etat") != null){
            lienDetail =pr.getLien() + "?but=fabrication/ordre-fabrication-details-fiche.jsp&etat="+request.getParameter("etat");
        }

        String lienTableau[] = {lienDetail, pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
        String colonneLien[] = {"id", "idingredients"};
        String[] attributLien = {"id", "id"};
        String colonneModal[] = {"id","idingredients"};
        pr.getTableau().setAttLien(attributLien);
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setAttLien(attributLien);
        pr.getTableau().setModalOnClick(true,colonneModal);
        Map<String,String> lienTab=new HashMap();
        lienTab.put("Fabriquer-idOffille",pr.getLien() + "?but=fabrication/fabrication-saisie.jsp");
        lienTab.put("Fabriquer un par un-idOffille",pr.getLien() + "?but=fabrication/fabrication-saisie.jsp&unParUn=true");
        lienTab.put("Situation globale",pr.getLien() + "?but=fabrication/offille-situation-globale.jsp");
        pr.getTableau().setLienClicDroite(lienTab);

        pr.getTableau().setLienFille("fabrication/inc/liste-fabrication-of.jsp&id=");
        //pr.getTableau().setData(listeFille);
        pr.getTableau().transformerDataString();


%>

<div class="box-body">
    <%
        String libEnteteAffiche[] = new String[]{"id", "ID Produit","D&eacute;signation", "Remarque", "Unit&eacute;","Qte Ordre"};
        if(mapUser.getIdrole().equals(ConstanteSocobis.CHEFFABR_RANG) || mapUser.getIdrole().equals(ConstanteSocobis.DG_RANG)) {
            libEnteteAffiche = new String[]{"id", "ID Produit","D&eacute;signation", "Remarque", "Unit&eacute;","Prix de vente","Prix de revient","Qt&eacute; Ordre","Qt&eacute; Fabriqu&eacute;","Qt&eacute; restante","Montant Th&eacute;orique","Valeur Fabriqu&eacute;e","D&eacute;pense de Fabrication","Taux de revient ( en %)"};
        }
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
    %>
    <div class="w-100" style="display: flex; flex-direction: row-reverse;">
        <table style="width: 20%"class="table">
            <tr>
                <td><b>Montant Revient:</b></td>
                <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(listeFille,"montantRevient")) %> Ar</b></td>
            </tr>
        </table>
    </div>
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

