<%@page import="utilitaire.Utilitaire"%>
<%@page import="bean.*"%>
<%@page import="utilitaire.*"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="facture.tr.Traite" %>
<%@ page import="caisse.Caisse" %>
<%
    try {

        Traite eng = new Traite();
        eng.setNomTable("TRAITEMTTRESTE_NONVERSEE");

        String mapping = "facture.tr.MvttIntraCaisse", classeFille = "facture.tr.MvtIntraCaisseFille",
                nomtable = "mvtintracaisse", nomTableFille = "mvtintracaisse_fille",
                apres = "facture/traite-fiche.jsp", colonneMere = "idmere",
                titre = "Transfert traite";

        String listeCrt[] = {"id","daty", "tiers", "banque","dateEcheance","reference","montant"};
        String listeInt[] = {"daty","montant","dateEcheance"};
        String libEntete[] = {"id","daty", "tiers", "banque","dateEcheance","reference","montant","etatlib"};
        PageRecherche pr = new PageRecherche(eng, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));

        pr.getFormu().getChamp("daty1").setLibelle("Date min");
        pr.getFormu().getChamp("daty2").setLibelle("Date max");
        pr.getFormu().getChamp("montant1").setLibelle("Montant Min");
        pr.getFormu().getChamp("montant2").setLibelle("Montant Max");
        pr.getFormu().getChamp("dateEcheance1").setLibelle("Date echeance min");
        pr.getFormu().getChamp("dateEcheance2").setLibelle("Date echeance max");
        pr.setOrdre(" order by dateEcheance asc");

       
        pr.setAWhere(" AND etat="+ConstanteEtat.getEtatValider()+" ");
        pr.setApres("facture/visa-traite-multiple.jsp");
        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);
        
        Caisse caisse=new Caisse();
        caisse.setDesce("Banque");
        Caisse[] listeCaisse=(Caisse[])CGenUtil.rechercher(caisse,null,null,"");
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1>Liste des traites a verser</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=facture/visa-traite-multiple.jsp" method="post" name="engagement" id="engagement">
            <% out.println(pr.getFormu().getHtmlEnsemble());%>

        </form>
        <%  
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <form action="<%=pr.getLien()%>?but=facture/apresTraite.jsp" method="post">
        
<!--        <div>
            <label>Caisse:</label>
            <select name="idcaisse" id="idcaisse">
                <%for(int i=0;i<listeCaisse.length;i++){%>
                <option value="<%=listeCaisse[i].getId()%>"><%=listeCaisse[i].getVal()%></option>
                <%}%>
            </select>
        </div>-->
        <div>
            <center>
            <label for="date">Date:</label>
            <input type="text" class="datepicker" onkeydown="return searchKeyPress(event)" name="date" id="date" value="<%=Utilitaire.dateDuJour()%>">
            </center>
        </div>
        
        <%
            String libEnteteAffiche[] = {"ID","Date", "Tiers", "banque","Date Echeance","Reference","Montant","Etat"};
            String lienTableau[] = {pr.getLien() + "?but=facture/traite-fiche.jsp"};
            String colonneLien[] = {"id"};
            pr.getTableau().setLien(lienTableau);
            pr.getTableau().setColonneLien(colonneLien);
            pr.getTableau().setLibelleAffiche(libEnteteAffiche);
            pr.getTableau().setNameBoutton("Transferer");
//            pr.getTableau().setNameActe("viserTraite");
            out.println(pr.getTableau().getHtmlWithCheckbox());
        %>
        <input type="hidden" name="action" id="action" value="viserTraite">
        <input type="hidden" name="acte" id="acte" value="viserTraite">
        <input type="hidden" name="bute" id="bute" value="facture/visa-traite-multiple.jsp">
        </form>
        <% out.println(pr.getBasPage()); %>
    </section>
</div>
<%  } catch (Exception e) {
        e.printStackTrace();
    }
%>