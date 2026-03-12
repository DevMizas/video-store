# 📱 Video Store

**Video Store** é um aplicativo Flutter inspirado no formato de feed vertical popularizado por redes sociais como TikTok, mas com uma proposta diferente: todo o conteúdo é **local e privado**.

O usuário pode adicionar vídeos diretamente do dispositivo e navegar por eles em um **feed vertical fluido**, explorar conteúdos em **grid** e salvar vídeos favoritos — tudo funcionando **100% offline**.

---

## 🎬 Demo

<img src="screenshots/demo.gif" width="300"/>

---

## 🚀 Features

- Feed vertical de vídeos estilo TikTok
- Grid de exploração com thumbnails geradas dinamicamente
- Sistema de favoritos
- Reprodução automática de vídeos
- Suporte a vídeos horizontais e verticais
- Armazenamento local persistente
- Gerenciamento de permissões para acesso à mídia
- Funciona **100% offline**

---

## 🧠 Tecnologias Utilizadas

- **Flutter**
- **Dart**
- **Clean Architecture**
- **MVVM**
- **GetIt (Dependency Injection)**

### Principais pacotes utilizados

- `video_player`
- `video_thumbnail`
- `shared_preferences`
- `path_provider`
- `file_picker`
- `permission_handler`

---

## 🏗️ Arquitetura

O projeto segue **Clean Architecture + MVVM**, garantindo separação clara entre responsabilidades e facilitando manutenção e escalabilidade.
