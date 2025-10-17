# sa_app_registro_ponto - Relatório de Implementação

## Descrição técnica da funcionalidade implementada e decisão de design
Este projeto é um aplicativo de registro de ponto para funcionário, desenvolvido em Flutter. 
A principal funcionalidade implementada foi:

- Autenticação de usuário usando **email corporativo (@cargo.connect.com)** e senha.
- Registro de ponto com **data, hora e localização** do funcionário.
- Verificação de distância máxima de 100 metros do local de trabalho usando **geolocalização**.
- Interface simples e clara, com telas de login, registro de ponto e visualização do registro.
- Gerenciamento de estado com **Provider** para manter os dados do usuário durante a sessão.
- Formatação de data e hora utilizando **intl** para exibir o registro de forma amigável.

### Decisão de design:
- Optei por não implementar biometria devido à complexidade e tempo disponível.
- O app é responsivo e organizado para facilitar o uso do funcionário.
- O desenvolvimento foi feito **apenas para Android**, pois estou acostumado a trabalhar nesta plataforma.

## Especificação do uso de API externa e integração com Firebase
O aplicativo utiliza as seguintes bibliotecas externas:

- **firebase_core**: inicialização do Firebase.
- **firebase_auth**: autenticação de usuário.
- **cloud_firestore**: armazenamento de registro de ponto.
- **geolocator**: captura da localização do usuário e cálculo de distância.
- **flutter_map + latlong2**: mapa para exibição da localização (opcional).
- **intl**: formatação de data e hora.

Integração com Firebase:
- Firebase Authentication para criar e gerenciar usuário.
- Firestore para armazenar registro de ponto com campos: `uid`, `dataHora`, `latitude`, `longitude`.

## Explicação do desafio encontrado e como foi resolvido
- **Validação de localização**: garantir que o registro só seja feito dentro de 100 metros. Resolvi usando Geolocator e calculando a distância entre o ponto do usuário e o ponto fixo da empresa.
- **Autenticação corporativa**: limitei o login apenas para email com domínio específico (@cargo.connect.com), usando validação simples antes de chamar o Firebase Auth.

# Desafios enfrentados:
- Permissão de geolocalização: foi necessário pesquisar como configurar corretamente o AndroidManifest.xml para que o app pudesse acessar a minha localização, o que levou algum tempo para entender a documentação do Flutter e do Geolocator.

Lógica de autenticação: desenvolver o AuthController para validar apenas email corporativo (@cargo.connect.com) e integrar corretamente com Firebase Auth percebi algumas dificuldades minhas na lógica de verificação e tratamento de erro, exigindo testes e ajustes.



# Documentação de Instalação e Uso

## Passo a passo para rodar o aplicativo localmente
1. Instale o Flutter seguindo a documentação oficial.
2. Clone o repositório do projeto.
3. Abra o terminal na pasta do projeto e rode:
flutter clean
flutter pub get
flutter run

yaml
Copiar código
4. O app será executado no emulador ou dispositivo Android conectado.

## Instruções para configurar Firebase e API utilizada
1. Ative o Firebase CLI:
dart pub global activate flutterfire_cli

markdown
Copiar código
2. Configure o Firebase para o projeto:
flutterfire configure

javascript
Copiar código
3. Adicione as seguintes dependências no `pubspec.yaml`:
firebase_core
firebase_auth
cloud_firestore
geolocator
provider
intl
flutter_map
latlong2

pgsql
Copiar código
4. Para geolocalização, adicione permissão no **AndroidManifest.xml**:
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION"/>
</manifest>
Não há integração com biometria. O login é feito apenas por email e senha corporativo.

Após configuração, rode o app:

arduino
Copiar código
flutter run
Observações finais
O projeto cumpre o requisito da avaliação, registrando ponto apenas quando estou próximo do local de trabalho e garantindo autenticação segura via Firebase.
A interface é simples e intuitiva, permitindo fácil registro e visualização do ponto.


