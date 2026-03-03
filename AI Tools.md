# AI Usage in this project
We declare that any and all AI usage within the project has been recorded and noted below. This includes (but is not limited to) usage of text generation methods incl. LLMs, text summarisation methods, or image generation methods. We understand that failing to divulge use of AI within our work counts as contract cheating and can result in a zero mark for SEP.


# Project AI


### AI tools used:

- ChatGPT (OpenAI language model, GPT-4 / GPT-5)


### How AI was used:

- As a learning aid while the team was initially learning the Dart language and Flutter framework.
- For debugging support, where AI explained compiler and runtime errors and suggested possible fixes.
- For assisting with the generation and interpretation of code coverage reports used to monitor automated testing.
- **.github/workflows/flutter.yml**: AI guided us on how to run automatic tests on GitHub so that it can deploy code changes every time a pull request is created. Especially in the "Setup and Install Flutter" section, AI helped with the configuration of the necessary files and environments for us to ensure that it is the same as our local development environment.



### How AI was not used:

- AI did not generate blocks of final code.
- AI did not independently design system architecture.
- AI did not influence the creative aspects of our design UI 


# Personal AI

## Layan:

I, Layan, declare that this document is accurate to my AI usage throughout the course of SEP.


### Development

- I used ChatGPT (OpenAI GPT4 / GPT5 series) to learn the dart language and find out how to interpret my UI designs in the language (such as how to add drop down shadow to my containers, visual alignment, etc.)

  
#### Prompts examples

- "How can I add a inner shadow/pressed effect to a button using BoxDecoration?”
- "How can I vertically center content inside a container while keeping consistent spacing across screens?"
- "What’s the difference between lowering opacity and blending colours when styling containers in Flutter?"
- "Which opacity would make this look less harsh?"


#### Why?

The frontend aesthetics are really pivitol to out overall purpose of the app. It needs to be welcoming and easy on the eyes so I needed to ensure that my visual componenets reflected that. By better understanding how Flutter UI properties work I am able to accurately translate visual design ideas into Dart code. I do depend on trial-and-error with things like spacing and alignment, but as a last resort I do use the help of AI.

  
### Debugging

- I used ChatGPT (OpenAI GPT4 / GPT5) for fixing bugs and understanding unexpected errors during development.

  
#### Prompts examples

- "Why am i getting this error? Can you explain how I can avoid it? : [ERROR PASTED]"
- “This layout is overflowing on smaller screens so how can I debug and fix it?”


#### Why?

To understand the cause of bugs and error messages and to apply correct fixes rather than relying on copying solutions without understanding them.


### Reviewing

- I used ChatGPT (OpenAI GPT4 / GPT5) to review and clarify some of my own code and UI implementation.

  
#### Prompts examples

- "Is this Flutter syntax valid?"
- "Does this error message relate to how I structured this widget?"

  
#### Why?

I used AI in this way to support understanding of flutter conventions while I am learning the framework.



## Daud:

I, Daud, declare that this document is accurate to my AI usage throughout the course of SEP.


### Development

I used ChatGPT (OpenAI GPT4 / GPT5) to research suitable architecture patterns, suggest appropriate tech stacks, and understand how to integrate supabase with flutter.


#### Prompts examples

- "How do I connect a Flutter app to supabase?"
- "How should I structure authentication flow in flutter?"


#### Why?

Since we had to make decisions about backend integration and app structure early on, I used AI to explore different options and understand them. I also needed help understanding how supabase works with flutter, especially around authentication. AI helped me grasp the concepts more quickly so I could implement them properly rather than relying on guesswork.


### Debugging

I used ChatGPT (OpenAI GPT4 / GPT5) to debug authentication issues and resolve problems related to supabase and Row Level Security (RLS).


#### Prompts examples

- "Why is my Supabase authentication failing?"
- "What causes this RLS policy error?"
- "How do I configure Supabase RLS policies correctly?"

  
#### Why?

Backend errors can be difficult to interpret, especially when dealing with authentication and database permissions. I used AI to understand what the error messages meant and what might be causing them. This helped me properly fix configuration issues instead of randomly changing policies or settings.


### Reviewing

I used ChatGPT (OpenAI GPT4 / GPT5) to review architecture decisions and confirm whether my implementation approach made sense.


#### Prompts examples

- "Is this a secure way to structure user data access?"
- "Am I handling async calls correctly in this function?"

  
#### Why?

When working on backend logic and authentication, small mistakes can cause larger issues later. I used AI to double check that my approach was reasonable while still making the final decisions myself.



## Carol:
I, Carol, declare that this document is accurate to my AI usage throughout the course of SEP.


### Development

I used ChatGPT (OpenAI GPT4 / GPT5) as a learning aid while developing my understanding of git and the dart programming language.


#### Prompts examples

- "Why does my UI not fill the entire screen even though I set width to double.infinity?"
- "How can I structure a Flutter page so it looks visually balanced?"
- "How do padding and margin affect widget positioning in Flutter?"


#### Why?

When I started using Flutter, I found the layout system confusing and sometimes unpredictable. I used AI to explain how spacing and structure worked so I could understand what I was doing instead of just guessing.


### Debugging

I used ChatGPT (OpenAI GPT4 / GPT5) to help debug layout and UI issues, particularly related to page spacing and empty space appearing at the bottom of screens.


#### Prompts examples

- "Why is there empty space at the bottom of my flutter page?"
- "How do I remove extra padding in a scaffold layout?"

  
#### Why?

Sometimes I would fix layout issues by trial and error without fully understanding what caused them. I used AI to explain why the empty space or spacing bugs were happening so I could properly fix them and avoid making the same mistakes again.


### Reviewing

I used ChatGPT (OpenAI GPT4 / GPT5) to double check my understanding of git workflows and my dart structure.


#### Prompts examples

- "Is there a cleaner way to structure this widget tree?"
- "Is this the correct git workflow when working on a feature branch?"


#### Why?

Since I was still learning both git and flutter, I sometimes wanted reassurance that I was doing things the right way. I used AI to clarify small doubts and make sure my approach made sense, rather than to rewrite or generate my work.



## Ziqian:
I, Ziqian, declare that this document is accurate to my AI usage throughout the course of SEP.

### Development
- I used ChatGPT (the GPT4o/GPT5.2) , Claude (Sonnet 4.5) to learn the Dart language, comparing it to the languages I had learned before such as C and Java. And also learned how to design an attractive user interface.
#### Prompts examples
- I have already learned other programming languages such as C and Java. How should I focus on learning Dart, this new language, so that I can design an app?
- What are some basic UI design principles for mobile wellbeing apps? How can layout, spacing, and color choices improve user experience?
- Can you explain how Flutter’s widget-based UI system works, especially layout widgets like Column, Row, and Expanded?
- I currently have a simple Flutter project with a text input box and a button. Regarding how to optimize the visual hierarchy and readability without rewriting the entire code.

#### Why?
Dart is a completely new language for me and there are no lectures to teach me. I think we can use AI to facilitate the learning process, similar to how we learn other programming languages.
I have absolutely no experience in designing UI and user interfaces. I'm not sure what a comfortable interface looks like. After creating the initial draft, I need to use AI for reference to design a user interface that is comfortable for people.
### Debugging
I used ChatGPT (the GPT4o/GPT5.2) , Claude (Sonnet 4.5) to fixing bugs and understanding unexpected errors during development.

#### Prompts examples

- The compiler has reported an error. Why did this happen? Please provide a detailed explanation.
- The CI test on Github failed. Could you please take a look and tell me where it didn't meet the requirements?
#### Why?
Most of the time, errors are not noticed by the programmer. I need to use the AI to assist me in identifying the errors and providing explanations, so that my code can run properly and not encounter the same issues again in the future.
### Reviewing
I used ChatGPT (the GPT4o/GPT5.2) , Claude (Sonnet 4.5) to review and clarify some of my own code and others' PR.
#### Prompts examples
- Is there anything wrong with this way I wrote my code? Can it be made more concise or how can it be improved? Please elaborate.
- This is a section from PR's of our team. Could you please explain in detail what this section is specifically about?

#### Why?
When I write my own code, I often don't know how to improve and enhance it. I would like to hear some suggestions from AI. If the suggestions are reasonable, I will consider making the necessary modifications.
For the code of my team members, there are some parts that I might not understand. I will ask the AI to provide me with detailed explanations so that I can grasp the content of the PR and be able to offer suggestions on my own, thereby helping our project to be better.

## Kylan:
I, Kylan, declare that this document is accurate to my AI usage throughout the course of SEP.

### Development
I use ChatGPT4/5, Claude 3.5 and Gemini to assist me in learning dart and to help me complete complex UI designs

#### Prompts examples
-When using the developed web page, how can I ensure that the font size and button size ratio will scale proportionally even if I change the web page size

#### Why?
The design of the front end is of great significance to user experience. If we fail to provide customers with a good sensory and usage experience, they may abandon this software. Therefore, I need "AI" to help me better learn dart and Flutter UI so that I can complete the functions and styles I need. 

### Debugging
I use Gemini to fix runtime exceptions and rendering issues (e.g., layout overflows) that occur after flutter run.

#### Prompts examples
-Why did I get an error saying that after setState () was called, dispose () was on my record page?

-The long press and click gestures of my gesture detector conflict. How can I ensure their smooth cooperation?"

#### Why?

In the recording reflection interface, the status of the recording is well managed, such as recording, stopping or canceling. There must be strong logic to ensure that it operates properly when used by users. AI can assist me and help me understand the correct code logic used in the gesture system

### Reviewing
I use ChatGPT (OpenAI GPT-4 / GPT-5) to check the code I write and identify any areas that might cause problems for users

#### Prompts examples
-Is there any potential risk in the code I wrote? Or due to the lack of professionalism in the written program, significant changes are needed later on.

-I have already implemented the function of saving and jumping back to the home page. Is there any way to prevent users from clicking the back button on their phones and then going back to the recording page?

#### Why?
As a student developing software for the first time, I often worry that my writing style is too clumsy. Therefore, I will use AI to review the logic of my code and make my program logic more rigorous and less prone to problems