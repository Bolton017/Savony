package calculBesoin;

import bean.CGenUtil;
import bean.ClassMAPTable;
import produits.Ingredients;
import stock.EtatStock;
import utils.ConstanteSavonnerie;

import java.sql.Connection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ResultatBesoinsParMatiere extends ClassMAPTable {
    private String id;
    private String idMatiere;
    private String idMatiereLib;
    private String uniteLib;
    private double quantiteBesoins;
    private double pu;
    private double quantiteEnStock;
    private double quantiteNecessaire;
    private double montantBesoins;
    private double montantEnStock;
    private double montantNecessaire;


    private static EtatStock getEtatEnStock(String idIng, Connection c,String idMagasin) throws Exception {
        EtatStock es = new EtatStock();
        es.setNomTable("V_ETATSTOCK_ING");
        es.setId(idIng);
        System.out.println(idIng+" "+idMagasin);
        EtatStock[] data = (EtatStock[]) CGenUtil.rechercher(es, null, null, c, "and idmagasin ='"+ idMagasin +"'");
        if (data.length == 0){
            return new EtatStock();
        }

        return data[0];
    }

    public ResultatBesoinsParMatiere() {
        setNomTable("V_RESULTAT_BESOINS_PAR_MATIERE");
    }

    public static ResultatBesoinsParMatiere[] parse(ResultatBesoins[] besoins, Connection c,String idMagasin) throws Exception {
        if (besoins == null || besoins.length == 0) {
            throw new Exception("Aucun besoin trouvé pour le produit spécifié.");
        }

        Map<String, ResultatBesoinsParMatiere> map = new HashMap<>();

        for (ResultatBesoins b : besoins) {
            String key = b.getIdMatiere();

            ResultatBesoinsParMatiere res = map.get(key);
            if (res == null) {
                res = new ResultatBesoinsParMatiere();
                res.setIdMatiere(b.getIdMatiere());
                res.setIdMatiereLib(b.getIdMatiereLib());
                res.setQuantiteBesoins(b.getQuantite());
                res.setUniteLib(b.getUniteLib());
                res.setPu(b.getPu());
                res.setMontantBesoins(b.getPu() * b.getQuantite());

                Ingredients ing = (Ingredients) new Ingredients().getById(b.getIdMatiere(),"AS_INGREDIENTS",c);
                EtatStock es = getEtatEnStock(b.getIdMatiere(), c, ing.getAtelier());
                res.setQuantiteEnStock(es.getReste());
                res.setMontantEnStock(b.getPu() * res.getQuantiteEnStock());
//                System.out.println("M Stock = " + res.getMontantEnStock());

                if (res.getQuantiteBesoins() <= res.getQuantiteEnStock()) {
                    res.setQuantiteNecessaire(0);
                } else {
                    res.setQuantiteNecessaire(res.getQuantiteBesoins() - res.getQuantiteEnStock());
                    res.setMontantNecessaire(b.getPu() * res.getQuantiteNecessaire());
                }

                map.put(key, res);
            } else {
                // 1️⃣ Somme des besoins
                res.setQuantiteBesoins(
                        res.getQuantiteBesoins() + b.getQuantite()
                );

                res.setMontantBesoins(
                        res.getQuantiteBesoins() * res.getPu()
                );

                if (res.getQuantiteBesoins() <= res.getQuantiteEnStock()) {
                    res.setQuantiteNecessaire(0);
                    res.setMontantNecessaire(0);
                } else {
                    double qteNecessaire =
                            res.getQuantiteBesoins() - res.getQuantiteEnStock();

                    res.setQuantiteNecessaire(qteNecessaire);
                    res.setMontantNecessaire(qteNecessaire * res.getPu());
                }
            }
        }

        return map.values().toArray(new ResultatBesoinsParMatiere[0]);
    }

    public static ResultatBesoinsParMatiere[] merge(
            List<ResultatBesoinsParMatiere[]> besoinsParProduits
    ) throws Exception {

        if (besoinsParProduits == null || besoinsParProduits.isEmpty()) {
            throw new Exception("Aucun besoin à fusionner.");
        }

        Map<String, ResultatBesoinsParMatiere> map = new HashMap<>();

        for (ResultatBesoinsParMatiere[] tableau : besoinsParProduits) {
            if (tableau == null) continue;

            for (ResultatBesoinsParMatiere b : tableau) {
                if (b == null) continue;

                String key = b.getIdMatiere();
                ResultatBesoinsParMatiere res = map.get(key);

                if (res == null) {
                    res = new ResultatBesoinsParMatiere();

                    res.setIdMatiere(b.getIdMatiere());
                    res.setIdMatiereLib(b.getIdMatiereLib());
                    res.setUniteLib(b.getUniteLib());
                    res.setPu(b.getPu());

                    res.setQuantiteEnStock(b.getQuantiteEnStock());
                    res.setMontantEnStock(b.getMontantEnStock());

                    res.setQuantiteBesoins(b.getQuantiteBesoins());
                    res.setMontantBesoins(b.getMontantBesoins());

                    res.setQuantiteNecessaire(b.getQuantiteNecessaire());
                    res.setMontantNecessaire(b.getMontantNecessaire());

                    map.put(key, res);
                } else {
                    res.setQuantiteBesoins(
                            res.getQuantiteBesoins() + b.getQuantiteBesoins()
                    );

                    res.setMontantBesoins(
                            res.getMontantBesoins() + b.getMontantBesoins()
                    );

                    res.setQuantiteNecessaire(
                            res.getQuantiteNecessaire() + b.getQuantiteNecessaire()
                    );

                    res.setMontantNecessaire(
                            res.getMontantNecessaire() + b.getMontantNecessaire()
                    );
                }
            }
        }

        if (map.isEmpty()) {
            throw new Exception("Résultat de fusion vide.");
        }

        return map.values().toArray(new ResultatBesoinsParMatiere[0]);
    }

    public double getPu() {
        return pu;
    }

    public void setPu(double pu) {
        this.pu = pu;
    }

    public String getUniteLib() {
        return uniteLib;
    }

    public void setUniteLib(String uniteLib) {
        this.uniteLib = uniteLib;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdMatiere() {
        return idMatiere;
    }

    public void setIdMatiere(String idMatiere) {
        this.idMatiere = idMatiere;
    }

    public String getIdMatiereLib() {
        return idMatiereLib;
    }

    public void setIdMatiereLib(String idMatiereLib) {
        this.idMatiereLib = idMatiereLib;
    }

    public double getQuantiteBesoins() {
        return quantiteBesoins;
    }

    public void setQuantiteBesoins(double quantiteBesoins) {
        this.quantiteBesoins = quantiteBesoins;
    }

    @Override
    public String getTuppleID() {
        return getId();
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public double getQuantiteEnStock() {
        return quantiteEnStock;
    }

    public void setQuantiteEnStock(double quantiteEnStock) {
        this.quantiteEnStock = quantiteEnStock;
    }

    public double getQuantiteNecessaire() {
        return quantiteNecessaire;
    }

    public void setQuantiteNecessaire(double quantiteNecessaire) {
        this.quantiteNecessaire = quantiteNecessaire;
    }

    public double getMontantBesoins() {
        return montantBesoins;
    }

    public void setMontantBesoins(double montantBesoins) {
        this.montantBesoins = montantBesoins;
    }

    public double getMontantEnStock() {
        return montantEnStock;
    }

    public void setMontantEnStock(double montantEnStock) {
        this.montantEnStock = montantEnStock;
    }

    public double getMontantNecessaire() {
        return montantNecessaire;
    }

    public void setMontantNecessaire(double montantNecessaire) {
        this.montantNecessaire = montantNecessaire;
    }
}
