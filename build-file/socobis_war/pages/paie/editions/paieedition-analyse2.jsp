<%@ page import="affichage.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="user.*" %>
<%@ page import="paie.edition.PaieEditionDetails" %>
<%
    try {

        PaieEditionDetails lv = new PaieEditionDetails();
        lv.setNomTable("details_paie_edition_finalpdf");

        String listeCrt[] = {"id", "nom", "poste", "mois", "annee", "matricule"};
        String listeInt[] = {};
        String moisDeJuillet = "Actuel";
        String m1 = request.getParameter("mois");
        if(m1!=null){
            moisDeJuillet = Utilitaire.nbToMois(Integer.valueOf(m1).intValue());
        }
        String[] pourcentage = {"nombrepargroupe"};
        String colDefaut[] = {"id", "nom", "poste", "matricule", "mois", "annee", "dateembauche", "numero_cnaps"};
        String somDefaut[] = {"salaire_de_base", "taux", "juillet", "indemnitedepresentationbrut", "indemnite_de_transport", "avantages_en_nature", "montant_brut", "cnaps", "brutcnaps", "imposable", "irsa", "netaprescalcul", "reductionpourpersonnesacharge", "irsanet", "net_a_payer"};

        String libEntete[] = {"id", "nom", "matricule",  "poste","moislib", "annee","salaire_de_base", "taux", "juillet", "indemnitedepresentationbrut", "indemnite_de_transport", "avantages_en_nature", "montant_brut", "cnaps", "brutcnaps", "imposable", "irsa", "netaprescalcul","irsanet", "net_a_payer"};
        String libEnteteAffiche[] = {"id", "Nom","Matricule","Poste","Mois","Ann&eacute;e","Salaire de base","Taux","Juillet","Indemnit&eacute  de pr&eacute;sentation","Indemnit&eacute de transport","Avantages ","Montant brut ","Cnaps","Cnaps brut","Imposable","Irsa","Net apr&egrave;s calcul","Irsa net","Net a payer"};

        PageRecherche pr = new PageRecherche(lv, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
//        PageRechercheGroupe pr = new PageRechercheGroupe(lv, request, listeCrt, listeInt, 3, colDefaut, somDefaut, pourcentage, colDefaut.length, somDefaut.length);
        //PageRechercheGroupe pr = new PageRechercheGroupe(lv, request, listeCrt, listeInt, 3, colGr, somDefaut, pourcentage, colGr.length, 4);
//        PageRechercheGroupe pr = new PageRechercheGroupe(o, req, vrt, listInterval, nbRange, colGr, sommGr, pourc, nbCol, somGr)
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));

        pr.setNpp(100);
        pr.getFormu().getChamp("mois").setDefaut(((utilitaire.Utilitaire.getMoisEnCours())+""));

        Liste[] liste = new Liste[1];
        liste[0] = new Liste("mois");
        liste[0].makeListeMois();

        pr.getFormu().getChamp("mois").setLibelle("Mois");
        pr.getFormu().getChamp("annee").setLibelle("Ann&eacute;");

        //pr.getFormu().getChamp("juillet").setLibelle("mois actuel");
        pr.setApres("paie/editions/socobisedition-analyse2.jsp");
        String[] colSomme = { "salaire_de_base", "juillet", "montant_brut","cnaps" };

        //pr.creerObjetPagePourc();
        pr.creerObjetPage(libEntete,colSomme);
        pr.getFormu().changerEnChamp(liste);

        String[] libelles = {" ", "Nombre", "Somme de salaire de base", "Somme de juillet", "Somme du montant brut","Somme de cnaps" };

        pr.getTableauRecap().setLibeEntete(libelles);
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1>Analyse MOA</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%=pr.getApres()%>" method="post" name="analyse" id="analyse">
            <%out.println(pr.getFormu().getHtmlEnsemble());%>
        </form>
        <%
            //String libEnteteAffiche[] = {"ID", "Nom", "Poste", "Matricule","mois","annee","Date embauche","Num cnaps","Sal Base","Taux",moisDeJuillet,"Ind. Prest. Brut","Ind. Trans.","Avan. Nature","Montant Brut","Cnaps","Brut Cnaps","Imposable","Irsa","Net apres Calc.","Reduction BAF","Irsa NET","Net &eacute; Payer"};
            String lienTableau[] = {pr.getLien() + "?but=paie/employe/personnel-fiche.jsp"};
            String colonneLien[] = {"id"};
            pr.getTableau().setLien(lienTableau);
            pr.getTableau().setColonneLien(colonneLien);
            pr.getTableau().setLibelleAffiche(libEnteteAffiche);
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>

<%
    } catch (Exception e) {
        e.printStackTrace();
    }
%>