
<%@page import="budget.UtilisateurService"%>
<%@page import="faturefournisseur.As_BonDeCommande"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.Liste"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="faturefournisseur.As_BonDeCommandeCpl" %>
<%@ page import="user.*" %>
<%@ page import="utils.ConstanteSavonnerie" %>
<%@ page import="utilitaire.Utilitaire" %>

<% try{
        UserEJB u = (UserEJB) session.getValue("u");
    String[] etatVal = {"AS_BONDECOMMANDE_CPL_MAGASIN","AS_BC_CPL_MAGASIN_CREE","AS_BC_CPL_MAGASIN_VISE_MAGAS","AS_BC_CPL_MAGASIN_VISE_CHEF_D","AS_BC_CPL_MAGASIN_VISE_DAF","AS_BC_CPL_MAGASIN_VISE_DG", "AS_BC_CPL_MAGASIN_ANNULE","AS_BONDECOMMANDE_MERECPL_RAL","AS_BONDECOMMANDE_MERECPL_RAF"};
    String[] etatAff = {"Tous","Cr&eacute;&eacute;e(s)", "Vis&eacute;e(s) par magasinier","Vis&eacute;e(s) par Chef du d&eacute;partement","Vis&eacute;e(s) par DAF","Vis&eacute;e(s) par Directeur", "Annul&eacute;e(s)","Avec reste &agrave; livrer", "Avec reste &agrave; facturer"};

    As_BonDeCommandeCpl f = new As_BonDeCommandeCpl();
    String nomTable = "AS_BONDECOMMANDE_MERECPL";
    if(request.getParameter("etat")!=null && request.getParameter("etat").compareToIgnoreCase("")!=0) {
        nomTable = request.getParameter("etat");
    }
    f.setNomTable(nomTable);
    String listeCrt[] = {"id","designation","daty","fournisseurlib","modepaiementlib", "remarque","montantTTC","montantTTCAriary"};
    String listeInt[] = {"daty","montantTTC","montantTTCAriary"};
//    String libEntete[] = {"remarque"};
    String libEntete[] = {"id","daty","designation","modepaiementlib","fournisseurlib","remarque","montantTTC","idDeviselib","montantTTCAriary","etatlib"};
    PageRecherche pr = new PageRecherche(f, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des bons de commande fournisseur");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("bondecommande/bondecommande-liste.jsp");
    String awhere = "";
//    if(request.getParameter("etat")!=null && request.getParameter("etat").compareToIgnoreCase("")!=0) {
//        awhere += " and etat=" + request.getParameter("etat");
//    }
    UtilisateurService us = new UtilisateurService();
    us.setRefuser(u.getUser().getTuppleID());
    us = us.getUserService(null);
    boolean roleViewer = u.getUser().getIdrole().equalsIgnoreCase(ConstanteSavonnerie.ROLE_DG)
            || u.getUser().getIdrole().equalsIgnoreCase(ConstanteSavonnerie.ROLE_CG)
            || u.getUser().getIdrole().equalsIgnoreCase(ConstanteSavonnerie.ROLE_CHEFFAB)
            || u.getUser().getIdrole().equalsIgnoreCase(ConstanteSavonnerie.ROLE_RESPACHAT);
    if (us != null && !roleViewer) {
        awhere += " and service='"+us.getIdService()+"'";
    }
    pr.setAWhere(awhere);
    pr.getFormu().getChamp("designation").setLibelle("D&eacute;signation"); 
    pr.getFormu().getChamp("fournisseurlib").setLibelle("Fournisseur");

    TypeObjet modePaiement= new TypeObjet();
    modePaiement.setNomTable("MODEPAIEMENT");
    Liste[] liste = new Liste[1];
    liste[0] = new Liste("modepaiementlib", modePaiement, "val", "val");
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("modepaiementlib").setLibelle("Mode de paiement");
//    pr.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("montantTTC1").setLibelle("Montant TTC min");
    pr.getFormu().getChamp("montantTTC2").setLibelle("Montant TTC max");
    pr.getFormu().getChamp("montantTTCAriary1").setLibelle("Montant TTC Ariary min");
    pr.getFormu().getChamp("montantTTCAriary2").setLibelle("Montant TTC Ariary max");
    String[] colSomme = {"montantTTCAriary"};
    pr.creerObjetPage(libEntete, colSomme);
    Map<String,String> lienTab=new HashMap();
    String[] id = {"daty1"};
    String[] val = {pr.getFormu().getChamp("daty1").getValeur()};
    String classe = "faturefournisseur.As_BonDeCommande";
    lienTab.put("viser",pr.getLien() + "?but=apresTarif.jsp&acte=valider&bute=bondecommande/bondecommande-liste.jsp&classe=" + classe+"&rajoutLien="+ Utilitaire.ajouterParam(id, val) );
    lienTab.put("dupliquer",pr.getLien() + "?but=bondecommande/bondecommande-saisie.jsp&acte=dupliquer");
    pr.getTableau().setLienClicDroite(lienTab);
    String enteteRecap[] = { "", "Nombre", "Somme des montants TTC en ariary"};
    pr.getTableauRecap().setLibeEntete(enteteRecap);
    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=bondecommande/bondecommande-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"Id","Date","D&eacute;signation","Mode de paiement","Fournisseur","Remarque","Montant TTC", "Devise","Montant TTC en Ariary","&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getTableau().setLienFille("bondecommande/inc/bondecommande-liste-detail.jsp&id=");
    pr.getFormu().setAnotherButton("" +
            "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=bondecommande/bondecommande-saisie.jsp\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i> Saisir un bon de commande</a>"
    );
%>
<script>
    function changerDesignation() {
        document.getElementById("bc-liste--form").submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" id="bc-liste--form" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row col-md-12 noppadding">
                <div class="col-md-2 noppadding">
                    &Eacute;tat :
                    <select name="etat" class="champ form-control" id="etat" onchange="changerDesignation()">
                        <%
                            for( int i = 0; i < etatAff.length; i++ ){ %>
                        <% if(request.getParameter("etat") !=null && request.getParameter("etat").compareToIgnoreCase(etatVal[i]) == 0) {%>
                        <option value="<%= etatVal[i] %>" selected> <%= etatAff[i] %> </option>
                        <% } else { %>
                        <option value="<%= etatVal[i] %>"> <%= etatAff[i] %> </option>
                        <% } %>
                        <%    }
                        %>
                    </select>
                </div>
            </div>
            <br>
        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
    <%
    }catch(Exception e){

        e.printStackTrace();
    }
%>
