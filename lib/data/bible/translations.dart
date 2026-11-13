import 'package:bible_garden/data/bible/bible_models.dart';

/// Traduções que aparecem no seletor. Só a Bíblia Livre tem o texto no app;
/// as outras ficam salvas como preferência até existir contrato.
const List<Translation> translations = [
  Translation(
    id: 'blivre',
    sigla: 'BLIVRE',
    nome: 'Bíblia Livre',
    status: LicenseStatus.liberada,
    credito:
        'Bíblia Livre (BLIVRE), © Diego Santos, Mario Sérgio e Marco Teles, '
        '2018 — CC BY 4.0 Brasil.',
  ),
  Translation(
    id: 'blt',
    sigla: 'BLT',
    nome: 'Bíblia Livre Para Todos',
    status: LicenseStatus.abertaPendente,
    editora: 'Licença aberta CC BY-SA 4.0',
  ),
  Translation(
    id: 'alm1911',
    sigla: 'ALM1911',
    nome: 'Almeida 1911',
    status: LicenseStatus.abertaPendente,
    editora: 'Domínio público',
  ),
  Translation(
    id: 'ara',
    sigla: 'ARA',
    nome: 'Almeida Revista e Atualizada',
    status: LicenseStatus.licencaNecessaria,
    editora: 'Sociedade Bíblica do Brasil',
  ),
  Translation(
    id: 'arc',
    sigla: 'ARC',
    nome: 'Almeida Revista e Corrigida',
    status: LicenseStatus.licencaNecessaria,
    editora: 'Sociedade Bíblica do Brasil',
  ),
  Translation(
    id: 'naa',
    sigla: 'NAA',
    nome: 'Nova Almeida Atualizada',
    status: LicenseStatus.licencaNecessaria,
    editora: 'Sociedade Bíblica do Brasil',
  ),
  Translation(
    id: 'ntlh',
    sigla: 'NTLH',
    nome: 'Nova Tradução na Linguagem de Hoje',
    status: LicenseStatus.licencaNecessaria,
    editora: 'Sociedade Bíblica do Brasil',
  ),
  Translation(
    id: 'nvi',
    sigla: 'NVI',
    nome: 'Nova Versão Internacional',
    status: LicenseStatus.licencaNecessaria,
    editora: 'Biblica',
  ),
  Translation(
    id: 'nvt',
    sigla: 'NVT',
    nome: 'Nova Versão Transformadora',
    status: LicenseStatus.licencaNecessaria,
  ),
  Translation(
    id: 'acf',
    sigla: 'ACF',
    nome: 'Almeida Corrigida Fiel',
    status: LicenseStatus.licencaNecessaria,
    editora: 'Sociedade Bíblica Trinitariana do Brasil',
  ),
  Translation(
    id: 'kja',
    sigla: 'KJA',
    nome: 'King James Atualizada',
    status: LicenseStatus.licencaNecessaria,
  ),
  Translation(
    id: 'ave',
    sigla: 'AVE',
    nome: 'Bíblia Ave-Maria',
    status: LicenseStatus.licencaNecessaria,
    editora: 'Edição católica',
    temDeuterocanonicos: true,
  ),
  Translation(
    id: 'cnbb',
    sigla: 'CNBB',
    nome: 'Bíblia da CNBB',
    status: LicenseStatus.licencaNecessaria,
    editora: 'Edição católica',
    temDeuterocanonicos: true,
  ),
];

Translation translationById(String id) => translations.firstWhere(
  (t) => t.id == id,
  orElse: () => translations.first,
);
