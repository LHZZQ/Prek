
<p align="center">
  <img src="prek-app/images/prek_logo.png" width="300" height="200">
</p>

<h1 align="center">2025-Prek</h1>

<div align="center">
  
[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)](https://supabase.io)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![Amazon AWS](https://img.shields.io/badge/Amazon%20AWS-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)](https://aws.amazon.com/)
[![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-2088FF?style=for-the-badge&logo=githubactions&logoColor=white)](https://github.com/features/actions)

</div>

## 目录
- [项目介绍](#项目介绍)
- [相关方](#相关方)
- [用户故事](#用户故事)
- [项目结构](#项目结构)
- [技术栈](#技术栈)
- [架构图](#架构图)
- [用户使用说明](#用户使用说明)
- [开发者说明](#开发者说明)
- [内部链接](#内部链接)
- [团队成员](#团队成员)

## 项目介绍
**Prek** 是一款关注身心健康的应用，旨在通过有引导的反思练习，帮助用户培养正念和积极心态。
应用会提供结构化的每日提示和日记记录功能，鼓励用户关注值得感恩的时刻，更有意识地生活，从而促进积极思考和情绪平衡。

**Prek** 的目标是打造一个简单、安静、积极的数字空间，帮助用户在日常生活中练习感恩、正念和有意识的生活方式。通过清晰的提示和流畅的记录体验，本项目希望帮助用户发现生活中的积极瞬间，缓解压力，并在长期使用中提升整体幸福感。

**主要功能**：
- 每天提供不同的肯定语
- 记录每日反思
- 查看过去的记录

## 相关方
- **个人客户**：项目负责人，负责把握应用的整体方向，并接收最终交付成果。

- **最终用户**：希望通过每日反思和感恩练习来提升正念水平与整体幸福感的用户。

- **学生团队**：负责设计和开发本应用的程序员与设计成员团队。

## 用户故事
**作为一名大学生，**

- 我希望能在课后快速记录自己感恩的事情，这样我可以保持更积极的心态，也能更好地应对学业压力。
  
- 我希望自己的感恩记录可以关联到具体日期或课程，这样我能看出日常安排中的哪些部分会影响我的幸福感。

**作为一名忙碌的职场人士，**

- 我希望每天有简短的提示来引导我的感恩反思，这样我不用额外花很多精力，也能坚持练习正念。
  
- 我希望在写感恩记录的同时记录自己的心情，这样我能发现哪些规律会影响我的专注度和工作生活平衡。

**作为一名正在关注心理健康的人，**

- 我希望可以回顾过去的感恩记录，这样我能看到自己的变化，也能在困难的日子里继续保持动力。

- 我希望能从记录中看到简单的趋势或高亮内容，这样我可以更好地理解什么会让我感到快乐。

## 发布计划

| 版本        | 说明                                               | 目标日期 | 状态  |
|----------------|-----------------------------------------------------------|--------------|----------|
| **MVP**         | 面向首次发布的核心功能。                    | 20/11/2025   | 已完成  |
| **Beta**        | 大部分功能已实现。                    | 19/02/2026   | 已完成  |
| **最终版本** | 完整功能与优化已完成，可用于正式发布。 | 30/04/2026   | 已完成  |

## 项目结构
```
2025-Prek
├─ .github/
│  ├─ workflows/     # CI / CD 流水线（Flutter 检查、测试等）
│  └─ PULL_REQUEST_TEMPLATE.md
├─ docs/minutes      # 文档与会议记录
├─ prek-app          # 项目根目录，包含所有源代码
├─ AI Tools.md       # AI 使用说明与覆盖范围
├─ CONTRIBUTING.md   # 贡献指南与开发流程
├─ ETHICS.md         # 伦理考虑与负责任设计
├─ LICENSE           # 项目许可证（MIT）
└─ README.md         # 项目概览与配置说明
```

## 技术栈
- **前端**：Flutter
- **后端**：Supabase
- **数据库**：PostgreSQL
  
## 架构图
<img width="1060" height="1484" alt="架构图" src="https://github.com/user-attachments/assets/01a08f2f-fa97-49b3-8ac5-382ff62271df" />

## 用户使用说明
1. 登录
    - 输入邮箱和密码，然后点击 '登录'。
    
2. 注册
   - 如果你是新用户，请点击 '注册' 按钮。
   - 输入用户名。
   - 输入邮箱。
   - 输入两次密码，用于确认。
   - 点击 '注册' 按钮后，账户就会创建完成。

3. 忘记密码
   - 如果忘记了密码，请点击 '忘记密码' 按钮。
   - 输入邮箱。
   - 如果你是已注册用户，系统会向你的邮箱发送 '重置密码' 链接。
   - 更新密码后，请重新登录。
    
4. 主页
   - 登录后，你每天都会看到一条新的肯定语。
   - 点击 '保存反思' 按钮来写反思。
   - 点击底部菜单栏中的图标，可以进入 '历史'、'我的'、'相册' 和 '设置'。

5. 反思页面
   - 选择一个 表情 来表示你今天的心情。
   - 你可以选择写一段反思、录制一段反思，或者上传一张图片到 相册。
   - 点击 '保存反思'，将内容关联到 历史 或 相册。
     
6. 历史页面
   - 这里会显示你过去的文字和语音反思，并附带时间戳和心情记录。
     
7. 个人资料页面
   - 这里可以查看你的用户名、邮箱和连续记录天数。
   - 这里也可以通过日历视图查看你之前的心情记录。

8. 相册 页面
   - 这里会显示你过去的图片反思和对应说明。
     
9. 设置页面
   - 你可以在这个页面修改姓名、邮箱和密码。
   - 点击保存后，你的信息会被更新。
   - 点击右上角按钮，可以在深色模式和浅色模式之间切换。
   - 点击 '退出登录' 按钮即可退出登录。

## 开发者说明
1. 安装 [Flutter](https://docs.flutter.dev/install/manual)
2. 在终端中克隆此仓库：
   
   ```
   git clone https://github.com/spe-uob/2025-Prek.git
   ```
3. 在终端中进入项目根目录并安装依赖：

    ```
     flutter pub get
    ```
4. 在终端中运行应用：
   
   ```
   flutter run
   ```
   
## 内部链接
- [看板](https://github.com/orgs/spe-uob/projects/342)
- [许可证](https://github.com/spe-uob/2025-Prek/blob/a588db8ce4e40b9cb71dcd3317db70c8fcda09c1/LICENSE)
- [伦理文档](https://github.com/spe-uob/2025-Prek/blob/dev/ETHICS.md)
- [AI 文档](https://github.com/spe-uob/2025-Prek/blob/dev/AI%20Tools.md)
- [贡献指南](https://github.com/spe-uob/2025-Prek/blob/dev/CONTRIBUTING.md)
  
## 团队成员

| 成员        | 邮箱                |
|----------------|----------------------|
| Carol Tan      |pn24594@bristol.ac.uk |
| Daud Ismail    |kk24104@bristol.ac.uk |
| Layan Alaskar（客户联络人）  |pk23085@bristol.ac.uk |
| Ziqian Zhang   |ni24790@bristol.ac.uk |
| Kylan Zou      |gn23627@bristol.ac.uk |

| 周数        | 项目经理      |
|-------------|----------------------|
| 2-7         |Layan Alaskar         |
| 8-12        |Daud Ismail           |
|13-18        |Carol Tan             |
|19-24        |Ziqian Zhang          |
