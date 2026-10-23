<%@page import="utilitaire.Utilitaire"%>
<%@page import="facture.tr.MvtIntraCaisseTraite"%>
<%@page import="bean.*"%>
<%@page import="utilitaire.*"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="caisse.Caisse" %>
<%
    try {

        MvtIntraCaisseTraite eng = new MvtIntraCaisseTraite();
        eng.setNomTable("MVTINTRACAISSETRAITEV");

        String listeCrt[] = {"id", "tiers","codeclient","facture","reference","idTraite","daty", "caissedepart", "caissearrivee","montant","dateecheance"};
        String listeInt[] = {"daty","montant","dateecheance"};
        String libEntete[] = {"id","tiers","codeclient", "facture","reference","idTraite","daty","dateecheance", "caissedepartlib", "caissearriveelib","montant"};
        PageRecherche pr = new PageRecherche(eng, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));

        pr.getFormu().getChamp("daty1").setLibelle("Date min");
        pr.getFormu().getChamp("daty2").setLibelle("Date max");
        pr.getFormu().getChamp("montant1").setLibelle("Montant Min");
        pr.getFormu().getChamp("montant2").setLibelle("Montant Max");
        pr.getFormu().getChamp("dateecheance1").setLibelle("Date &Eacute;ch&eacute;ance Min");
        pr.getFormu().getChamp("dateecheance2").setLibelle("Date &Eacute;ch&eacute;ance Max");
        pr.getFormu().getChamp("caissedepart").setLibelle("Caisse Depart");
        pr.getFormu().getChamp("caissearrivee").setLibelle("Caisse Arrivee");
       
        pr.setAWhere(" AND idTraite is not null AND etatversement = "+ConstanteEtat.getEtatValider());
        pr.setApres("facture/traite-encaissement-versee-liste.jsp");
        pr.setOrdre(" order by dateEcheance asc");

        pr.getFormu().getChamp("daty1").setDefaut(Utilitaire.dateDuJour());
        pr.getFormu().getChamp("daty2").setDefaut(Utilitaire.dateDuJour());

        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);
        
        Caisse caisse=new Caisse();
        //caisse.setDesce("Banque");
        Caisse[] listeCaisse=(Caisse[])CGenUtil.rechercher(caisse,null,null,"");
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1>Liste des traites en attente d'avis de credit</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=facture/traite-encaissement-versee-liste.jsp" method="post" name="engagement" id="engagement">
            <% out.println(pr.getFormu().getHtmlEnsemble());%>

        </form>
        <%  
            String lienTableau[] = {pr.getLien() + "?but=facture/traite-encaissement-versee-fiche.jsp",pr.getLien() + "?but=facture/traite-fiche.jsp"};
            String colonneLien[] = {"id","idTraite"};
            pr.getTableau().setLien(lienTableau);
            pr.getTableau().setColonneLien(colonneLien);
            out.println(pr.getTableauRecap().getHtml());
        %>
        <br>
        <form action="<%=pr.getLien()%>?but=facture/apresVerserTraite.jsp" method="post">
         
        <div class="row col-md-12">
            <div class="row">
                <div class="col-md-4">
                    Remarque:
                    <input type="text" name="remarque" id="remarque" class="form-control">
                </div>
                <div class="col-md-4">
                    Caisse:
                    <select name="idcaisse" id="idcaisse" class="form-control">
                        <%for(int i=0;i<listeCaisse.length;i++){%>
                        <option value="<%=listeCaisse[i].getId()%>"><%=listeCaisse[i].getVal()%></option>
                        <%}%>
                    </select>
                </div>
                <div class="col-md-4">
                    Date:
                    <input type="text" class="datepicker form-control" onkeydown="return searchKeyPress(event)" name="date" id="date" value="<%=Utilitaire.dateDuJour()%>">
                </div>
            </div>
            </br>
        </div>
        <br>
        
        <%
            String libEnteteAffiche[] = {"id","tiers","codeclient","facture", "r&eacute;f&eacute;rence","Traite","Date transfert","Date echeance", "Caisse Depart", "Caisse Arrivee","Montant"};
            pr.getTableau().setLibelleAffiche(libEnteteAffiche);
            pr.getTableau().setNameBoutton("Encaisser");
            pr.getTableau().setNameActe("encaissementTraite");
            if (pr.getTableau().getHtmlWithCheckbox() != null) {
                out.println(pr.getTableau().getHtmlWithCheckbox());
            }
        %>
        <input type="hidden" name="acte" id="acte" value="encaissementTraite">
        <input type="hidden" name="action" id="action" value="encaissementTraite">
        <input type="hidden" name="bute" id="bute" value="facture/traite-encaissement-versee-liste.jsp">
        </form>
        <% out.println(pr.getBasPage()); %>
    </section>
</div>
<%  } catch (Exception e) {
        e.printStackTrace();
    }
%>