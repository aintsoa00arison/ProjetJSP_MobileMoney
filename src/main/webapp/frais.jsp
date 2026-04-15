<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, mg.vola.dao.FraisDAO, mg.vola.models.FraisEnvoi, mg.vola.models.FraisRecep" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NovaCash | Grille Tarifaire</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --main-dark: #0F172A;
            --accent-mint: #2DD4BF;
            --bg-page: #F1F5F9;
        }

        body { 
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg-page); 
            color: var(--main-dark);
        }

        /* --- ELEMENTS DE DESIGN --- */
        .header-section { 
            background: white; 
            border-left: 5px solid var(--accent-mint);
            border-radius: 15px;
        }

        .card { border: none; border-radius: 20px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
        
        .nav-pills .nav-link {
            color: var(--main-dark) !important;
            border-radius: 50px;
            padding: 10px 25px;
            font-weight: 600;
            transition: 0.3s;
            border: 1px solid transparent;
        }
        
        .nav-pills .nav-link.active {
            background-color: var(--main-dark) !important;
            color: var(--accent-mint) !important;
        }

        .table thead { background-color: var(--main-dark); color: white; }
        .table thead th { border: none; padding: 15px; font-size: 0.85rem; text-transform: uppercase; }

        .btn-mint {
            background-color: var(--accent-mint);
            color: var(--main-dark);
            font-weight: 600;
            border: none;
        }
        .btn-dark-nova { background-color: var(--main-dark); color: white; border: none; }

        .search-bar { 
            border-radius: 50px !important; 
            padding-left: 20px; 
            border: 2px solid #e2e8f0 !important; 
        }
        .search-bar:focus { border-color: var(--accent-mint) !important; box-shadow: none; }

        .price-text { color: #0d9488; font-weight: 700; }
    </style>
</head>
<body>

<%@ include file="navbar.jsp" %>

<div class="container py-5">
    
    <div class="header-section shadow-sm p-4 mb-5 d-flex justify-content-between align-items-center">
        <div>
            <h2 class="mb-0 fw-bold">Grille Tarifaire</h2>
            <p class="mb-0 text-muted">Configuration des commissions d'envoi et de retrait</p>
        </div>
    </div>

    <div class="row mb-4 align-items-center">
        <div class="col-md-6">
            <input type="text" id="searchFrais" class="form-control search-bar" placeholder="Rechercher une tranche tarifaire...">
        </div>
        <div class="col-md-6 text-md-end mt-3 mt-md-0">
            <button class="btn btn-dark-nova rounded-pill px-4 py-2 shadow-sm" type="button" data-bs-toggle="collapse" data-bs-target="#formFrais">
                + Nouvelle Tranche
            </button>
        </div>
    </div>

    <div class="collapse mb-5" id="formFrais">
        <div class="card border-0">
            <div class="card-body p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h5 class="fw-bold m-0">Nouvelle Règle Tarifaire</h5>
                    <button type="button" class="btn-close" data-bs-toggle="collapse" data-bs-target="#formFrais"></button>
                </div>
                <form action="FraisServlet" method="POST" class="row g-3">
                    <input type="hidden" name="action" value="ajouter">
                    <div class="col-md-2">
                        <label class="form-label small fw-bold">Type de Flux</label>
                        <select name="type_frais" class="form-select">
                            <option value="ENVOI">Frais d'envoi</option>
                            <option value="RECEP">Frais de retrait</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label small fw-bold">Code (ID)</label>
                        <input type="text" name="id" class="form-control" placeholder="E100" required>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label small fw-bold">Montant Min (Ar)</label>
                        <input type="number" name="montant1" class="form-control" required>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label small fw-bold">Montant Max (Ar)</label>
                        <input type="number" name="montant2" class="form-control" required>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label small fw-bold">Frais (Ar)</label>
                        <input type="number" name="valeur" class="form-control" required>
                    </div>
                    <div class="col-12 text-end mt-4">
                        <button type="submit" class="btn btn-mint px-5 rounded-pill shadow-sm">Enregistrer la règle</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="card">
        <div class="card-body p-4">
            <ul class="nav nav-pills mb-4" id="pills-tab" role="tablist">
                <li class="nav-item">
                    <button class="nav-link active" data-bs-toggle="pill" data-bs-target="#tab-envoi">Frais d'envoi</button>
                </li>
                <li class="nav-item">
                    <button class="nav-link" data-bs-toggle="pill" data-bs-target="#tab-recep">Frais de retrait</button>
                </li>
            </ul>

            <div class="tab-content">
                <% FraisDAO dao = new FraisDAO(); %>

                <div class="tab-pane fade show active" id="tab-envoi">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead>
                                <tr>
                                    <th class="ps-4">Tranche de montant</th>
                                    <th>Valeur de commission</th>
                                    <th class="text-center">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<FraisEnvoi> listeEnv = dao.listerFraisEnv();
                                    for(FraisEnvoi e : listeEnv) {
                                %>
                                <tr class="frais-row">
                                    <td class="ps-4">De <b><%= String.format("%, d", e.getMontant1()) %></b> à <b><%= String.format("%, d", e.getMontant2()) %> Ar</b></td>
                                    <td class="price-text"><%= String.format("%, d", e.getFrais_env()) %> Ar</td>
                                    <td class="text-center">
                                        <button class="btn btn-sm btn-outline-dark rounded-pill px-3 me-2" 
                                            onclick="ouvrirModale('ENVOI', '<%= e.getIdEnv() %>', <%= e.getMontant1() %>, <%= e.getMontant2() %>, <%= e.getFrais_env() %>)">
                                            Editer
                                        </button>
                                        <form action="FraisServlet" method="POST" class="d-inline">
                                            <input type="hidden" name="action" value="supprimer">
                                            <input type="hidden" name="type_frais" value="ENVOI">
                                            <input type="hidden" name="id" value="<%= e.getIdEnv() %>">
                                            <button type="submit" class="btn btn-link text-danger btn-sm text-decoration-none" onclick="return confirm('Supprimer cette règle ?')">Supprimer</button>
                                        </form>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="tab-pane fade" id="tab-recep">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead>
                                <tr>
                                    <th class="ps-4">Tranche de montant</th>
                                    <th>Valeur de commission</th>
                                    <th class="text-center">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<FraisRecep> listeRec = dao.listerFraisRec();
                                    for(FraisRecep r : listeRec) {
                                %>
                                <tr class="frais-row">
                                    <td class="ps-4">De <b><%= String.format("%, d", r.getMontant1()) %></b> à <b><%= String.format("%, d", r.getMontant2()) %> Ar</b></td>
                                    <td class="price-text"><%= String.format("%, d", r.getFrais_rec()) %> Ar</td>
                                    <td class="text-center">
                                        <button class="btn btn-sm btn-outline-dark rounded-pill px-3 me-2"
                                            onclick="ouvrirModale('RECEP', '<%= r.getIdRec() %>', <%= r.getMontant1() %>, <%= r.getMontant2() %>, <%= r.getFrais_rec() %>)">
                                            Editer
                                        </button>
                                        <form action="FraisServlet" method="POST" class="d-inline">
                                            <input type="hidden" name="action" value="supprimer">
                                            <input type="hidden" name="type_frais" value="RECEP">
                                            <input type="hidden" name="id" value="<%= r.getIdRec() %>">
                                            <button type="submit" class="btn btn-link text-danger btn-sm text-decoration-none" onclick="return confirm('Supprimer cette règle ?')">Supprimer</button>
                                        </form>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="modalFrais" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <form action="FraisServlet" method="POST" class="modal-content border-0 shadow-lg">
            <div class="modal-header bg-dark text-white">
                <h5 class="modal-title fw-bold">Modifier la règle tarifaire</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <input type="hidden" name="action" value="modifier">
                <input type="hidden" name="type_frais" id="m_type">
                <input type="hidden" name="id" id="m_id">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label small fw-bold">Montant Minimum</label>
                        <input type="number" name="montant1" id="m_m1" class="form-control" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label small fw-bold">Montant Maximum</label>
                        <input type="number" name="montant2" id="m_m2" class="form-control" required>
                    </div>
                    <div class="col-12">
                        <label class="form-label small fw-bold">Valeur des frais (Ar)</label>
                        <input type="number" name="valeur" id="m_val" class="form-control" required>
                    </div>
                </div>
            </div>
            <div class="modal-footer border-0">
                <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Annuler</button>
                <button type="submit" class="btn btn-dark-nova rounded-pill px-4">Sauvegarder</button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('searchFrais').addEventListener('keyup', function() {
        let val = this.value.toLowerCase();
        document.querySelectorAll('.frais-row').forEach(row => {
            row.style.display = row.innerText.toLowerCase().includes(val) ? "" : "none";
        });
    });

    function ouvrirModale(type, id, m1, m2, val) {
        document.getElementById('m_type').value = type;
        document.getElementById('m_id').value = id;
        document.getElementById('m_m1').value = m1;
        document.getElementById('m_m2').value = m2;
        document.getElementById('m_val').value = val;
        new bootstrap.Modal(document.getElementById('modalFrais')).show();
    }
</script>
</body>
</html>