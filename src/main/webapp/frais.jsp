<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, mg.vola.dao.FraisDAO, mg.vola.models.FraisEnvoi, mg.vola.models.FraisRecep" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>M-Vola | Configuration des Frais</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f4f7f6; }
        .header-vola { background: linear-gradient(90deg, #ffcc00, #ffb300); color: #000; }
        .card { border: none; border-radius: 12px; }
        .nav-pills .nav-link.active { background-color: #212529; }
        .nav-link { color: #212529; font-weight: bold; }
        .search-bar { border-radius: 50px !important; max-width: 350px; border: 1px solid #ddd !important; }
        
        /* Style des Toasts */
        .toast-container { z-index: 1060; }
        .toast { min-width: 300px; border-radius: 10px; overflow: hidden; }
        .toast-header { border-bottom: none; padding: 12px; }
    </style>
</head>
<body>

<div class="container py-5">
    
    <div class="header-vola shadow-sm p-4 rounded-4 mb-4 d-flex justify-content-between align-items-center">
        <div>
            <h2 class="mb-0 fw-bold">📊 Grille Tarifaire</h2>
            <p class="mb-0 opacity-75">Gestion des commissions d'envoi et de retrait</p>
        </div>
        <a href="index.jsp" class="btn btn-dark rounded-pill px-4">Accueil</a>
    </div>

    <div class="row mb-4 align-items-center">
        <div class="col-md-6">
            <input type="text" id="searchFrais" class="form-control search-bar shadow-sm" placeholder="Rechercher un montant ou un ID...">
        </div>
        <div class="col-md-6 text-md-end">
            <button class="btn btn-success shadow-sm rounded-pill px-4" type="button" data-bs-toggle="collapse" data-bs-target="#formFrais">
                + Nouvelle Tranche
            </button>
        </div>
    </div>

    <div class="collapse mb-4" id="formFrais">
        <div class="card shadow-sm border-start border-4 border-success">
            <div class="card-body p-4 position-relative">
                <button type="button" class="btn-close position-absolute top-0 end-0 m-3" data-bs-toggle="collapse" data-bs-target="#formFrais"></button>
                <h5 class="fw-bold mb-3">Enregistrer une nouvelle règle</h5>
                <form action="FraisServlet" method="POST" class="row g-3">
                    <input type="hidden" name="action" value="ajouter">
                    <div class="col-md-2">
                        <label class="form-label small fw-bold">Type</label>
                        <select name="type_frais" class="form-select">
                            <option value="ENVOI">Envoi (FRAIS_ENVOI)</option>
                            <option value="RECEP">Retrait (FRAIS_RECEP)</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label small fw-bold">ID</label>
                        <input type="text" name="id" class="form-control" placeholder="ex: E10" required>
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
                        <label class="form-label small fw-bold">Valeur Frais (Ar)</label>
                        <input type="number" name="valeur" class="form-control" required>
                    </div>
                    <div class="col-12 text-end mt-3">
                        <button type="submit" class="btn btn-primary rounded-pill px-4 shadow-sm">Valider l'enregistrement</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="card shadow-sm">
        <div class="card-body p-4">
            <ul class="nav nav-pills mb-4" id="pills-tab" role="tablist">
                <li class="nav-item">
                    <button class="nav-link active" data-bs-toggle="pill" data-bs-target="#tab-envoi">Frais d'Envoi</button>
                </li>
                <li class="nav-item">
                    <button class="nav-link" data-bs-toggle="pill" data-bs-target="#tab-recep">Frais de Retrait</button>
                </li>
            </ul>

            <div class="tab-content">
                <% FraisDAO dao = new FraisDAO(); %>

                <div class="tab-pane fade show active" id="tab-envoi">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-dark">
                                <tr>
                                    <th>ID</th>
                                    <th>Tranche de montant</th>
                                    <th>Frais</th>
                                    <th class="text-center">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<FraisEnvoi> listeEnv = dao.listerFraisEnv();
                                    for(FraisEnvoi e : listeEnv) {
                                %>
                                <tr class="frais-row">
                                    <td><span class="badge bg-secondary"><%= e.getIdEnv() %></span></td>
                                    <td>De <b><%= String.format("%, d", e.getMontant1()) %></b> à <b><%= String.format("%, d", e.getMontant2()) %> Ar</b></td>
                                    <td class="text-danger fw-bold"><%= String.format("%, d", e.getFrais_env()) %> Ar</td>
                                    <td class="text-center">
                                        <button class="btn btn-sm btn-outline-primary rounded-pill px-3" 
                                            onclick="ouvrirModale('ENVOI', '<%= e.getIdEnv() %>', <%= e.getMontant1() %>, <%= e.getMontant2() %>, <%= e.getFrais_env() %>)">
                                            Modifier
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
                            <thead class="table-dark text-warning">
                                <tr>
                                    <th>ID</th>
                                    <th>Tranche de montant</th>
                                    <th>Frais</th>
                                    <th class="text-center">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<FraisRecep> listeRec = dao.listerFraisRec();
                                    for(FraisRecep r : listeRec) {
                                %>
                                <tr class="frais-row">
                                    <td><span class="badge bg-secondary"><%= r.getIdRec() %></span></td>
                                    <td>De <b><%= String.format("%, d", r.getMontant1()) %></b> à <b><%= String.format("%, d", r.getMontant2()) %> Ar</b></td>
                                    <td class="text-success fw-bold"><%= String.format("%, d", r.getFrais_rec()) %> Ar</td>
                                    <td class="text-center">
                                        <button class="btn btn-sm btn-outline-primary rounded-pill px-3"
                                            onclick="ouvrirModale('RECEP', '<%= r.getIdRec() %>', <%= r.getMontant1() %>, <%= r.getMontant2() %>, <%= r.getFrais_rec() %>)">
                                            Modifier
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
        <form action="FraisServlet" method="POST" class="modal-content border-0 shadow">
            <div class="modal-header bg-dark text-white">
                <h5 class="modal-title fw-bold">Modifier la règle <span id="displayId"></span></h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <input type="hidden" name="action" value="modifier">
                <input type="hidden" name="type_frais" id="m_type">
                <input type="hidden" name="id" id="m_id">
                
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label fw-bold small text-uppercase">Montant Minimum</label>
                        <input type="number" name="montant1" id="m_m1" class="form-control" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold small text-uppercase">Montant Maximum</label>
                        <input type="number" name="montant2" id="m_m2" class="form-control" required>
                    </div>
                    <div class="col-12">
                        <label class="form-label fw-bold small text-uppercase">Valeur des frais (Ar)</label>
                        <input type="number" name="valeur" id="m_val" class="form-control" required>
                    </div>
                </div>
            </div>
            <div class="modal-footer border-0 p-3">
                <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Annuler</button>
                <button type="submit" class="btn btn-dark rounded-pill px-4 shadow-sm">Sauvegarder</button>
            </div>
        </form>
    </div>
</div>

<div class="toast-container position-fixed bottom-0 end-0 p-3">
    <div id="liveToast" class="toast border-0 shadow-lg" role="alert" aria-live="assertive" aria-atomic="true">
        <div id="toastHeader" class="toast-header text-white">
            <strong class="me-auto" id="toastTitle">Grille Tarifaire</strong>
            <small>À l'instant</small>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
        <div class="toast-body bg-white rounded-bottom" id="toastMessage"></div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Recherche dynamique
    document.getElementById('searchFrais').addEventListener('keyup', function() {
        let val = this.value.toLowerCase();
        document.querySelectorAll('.frais-row').forEach(row => {
            row.style.display = row.innerText.toLowerCase().includes(val) ? "" : "none";
        });
    });

    // Ouverture modale
    function ouvrirModale(type, id, m1, m2, val) {
        document.getElementById('m_type').value = type;
        document.getElementById('m_id').value = id;
        document.getElementById('displayId').innerText = "(" + id + ")";
        document.getElementById('m_m1').value = m1;
        document.getElementById('m_m2').value = m2;
        document.getElementById('m_val').value = val;
        new bootstrap.Modal(document.getElementById('modalFrais')).show();
    }

    // Gestion des notifications Toast au chargement
    window.onload = function() {
        const urlParams = new URLSearchParams(window.location.search);
        const msg = urlParams.get('msg');
        
        if (msg) {
            const toastEl = document.getElementById('liveToast');
            const headerEl = document.getElementById('toastHeader');
            const titleEl = document.getElementById('toastTitle');
            const bodyEl = document.getElementById('toastMessage');
            
            if (msg === 'success') {
                headerEl.classList.add('bg-success');
                titleEl.innerText = "✅ Succès";
                bodyEl.innerText = "La règle tarifaire a été enregistrée avec succès.";
            } else {
                headerEl.classList.add('bg-danger');
                titleEl.innerText = "❌ Échec";
                bodyEl.innerText = "Une erreur est survenue lors de l'enregistrement.";
            }
            
            new bootstrap.Toast(toastEl, { delay: 4000 }).show();
            // Nettoyer l'URL
            window.history.replaceState({}, document.title, window.location.pathname);
        }
    }
</script>
</body>
</html>