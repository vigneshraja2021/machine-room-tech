# Which AI Is Actually Best at Tamil?

Machine Room Tech video #3. Six Tamil questions, five AIs, first answer only, scored blind.

## Final score (out of 60)

| AI | Score |
|---|---|
| ChatGPT (free model) | 45 |
| Gemini (free model, Flash-Lite) | 41 |
| Nemotron 3.5 Bolt E4B (Ollama, CPU) | 27 |
| Gemma 4 E4B (Ollama, CPU) | 22 |
| Qwen 3.5 4B (Ollama, CPU) | 6 |

## How it was tested

- Same prompts (below), pasted exactly, one fresh chat each, first answer only.
- ChatGPT and Gemini: their free models, recorded on screen (Gemini's model picker showed Flash-Lite).
- Local models: Ollama 0.40.13 on an Intel Core Ultra 5 125H laptop, 16 GB RAM, no graphics card. Thinking off, Ollama defaults, the same 1,500-token limit for all (only Qwen's Round 3 hit it).
- Judge: Claude (Opus) scored all 30 answers 0–10 blind: answers shuffled as A–E per round, names hidden, with an answer key. Most of the score is correctness, the rest is natural Tamil; a made-up fact caps an answer at 4. Claude was not a contestant.

## The prompts and every answer

### Round 1: Thirukkural

```
இந்தத் திருக்குறளுக்கு எளிய தமிழில் பொருள் சொல்லுங்கள், ஒரு அன்றாட உதாரணத்துடன். இது எந்த அதிகாரத்தில் வருகிறது?

இனிய உளவாக இன்னாத கூறல்
கனியிருப்பக் காய்கவர்ந் தற்று
```

| AI | Score | Judge's reason | Answer |
|---|---|---|---|
| ChatGPT (free model) | 10 | Correctly identifies Kural 100 in இனியவை கூறல் (adhikaram 10), explains the fruit analogy clearly, and gives a natural, relatable child-breaks-a-glass example. | [r1-chatgpt.txt](answers/r1-chatgpt.txt) |
| Gemini (free model, Flash-Lite) | 4 | Meaning and the ripe-mango example are clear and correct. The adhikaram is mangled into made-up names (இன்சொல் கூமை, இன்சொல்வழாமை) with stray Bengali script, so it is capped at 4. | [r1-gemini.txt](answers/r1-gemini.txt) |
| Qwen 3.5 4B (Ollama, CPU) | 1 | The explanation has nothing to do with the kural and the example is incoherent. The chapter it names does not exist. | [r1-qwen35-4b.txt](answers/r1-qwen35-4b.txt) |
| Gemma 4 E4B (Ollama, CPU) | 3 | Meaning is roughly right, though a Bengali word slips in. The adhikaram section is hedged nonsense (குறையாத செம்மை, அகத்திணை, a 'fifth root' grammar rule). | [r1-gemma4-e4b.txt](answers/r1-gemma4-e4b.txt) |
| Nemotron 3.5 Bolt E4B (Ollama, CPU) | 4 | The basic meaning and the sad-friend example are fine. It names a non-existent adhikaram and later muddles the fruit analogy, so it is capped at 4. | [r1-nemotron-35-bolt-e4b.txt](answers/r1-nemotron-35-bolt-e4b.txt) |

### Round 2: Proverb

```
"ஆற்றில் போட்டாலும் அளந்து போடு" என்ற பழமொழியின் பொருள் என்ன? இதை எந்தச் சூழ்நிலையில் சொல்வோம்? ஒரு உதாரணம் தாருங்கள்.
```

| AI | Score | Judge's reason | Answer |
|---|---|---|---|
| ChatGPT (free model) | 7 | Captures the core idea of measured, thrifty use even when it seems pointless, with sensible situations. Reading it literally as pouring water into a river is off, and the cooking example is a little weak. | [r2-chatgpt.txt](answers/r2-chatgpt.txt) |
| Gemini (free model, Flash-Lite) | 9 | Exactly right: even money as good as thrown away should be spent with count; good situation and a natural father-son example. Minor slip: 'அறிவுரைக் கூறினார்' has an extra க். | [r2-gemini.txt](answers/r2-gemini.txt) |
| Qwen 3.5 4B (Ollama, CPU) | 1 | Completely wrong meaning about trust and tying someone up and throwing them in a river, called a song from old literature. Repetitive, broken Tamil. | [r2-qwen35-4b.txt](answers/r2-qwen35-4b.txt) |
| Gemma 4 E4B (Ollama, CPU) | 4 | Confidently claims 'putting in the river' means a big, challenging task, turning the proverb into 'give full effort'. Fluent Tamil, but an invented meaning caps it at 4. | [r2-gemma4-e4b.txt](answers/r2-gemma4-e4b.txt) |
| Nemotron 3.5 Bolt E4B (Ollama, CPU) | 5 | Drifts to planning and avoiding hasty decisions; the 'keep count even when giving it away' sense is mostly missing. The investment example is in natural spoken Tamil. | [r2-nemotron-35-bolt-e4b.txt](answers/r2-nemotron-35-bolt-e4b.txt) |

### Round 3: Grammar trap

```
இந்த இரண்டு சொற்களையும் பிரித்து எழுதி, என்ன புணர்ச்சி மாற்றம் நடக்கிறது என்று விளக்குங்கள்:
1) பொற்குடம்
2) மரவேர்
```

| AI | Score | Judge's reason | Answer |
|---|---|---|---|
| ChatGPT (free model) | 4 | Clean and correct for பொற்குடம் (ன் → ற், மெய் திரிதல்). For மரவேர் it wrongly says ம் turns into வ் instead of simply dropping (கெடுதல்); capped at 4. | [r3-chatgpt.txt](answers/r3-chatgpt.txt) |
| Gemini (free model, Flash-Lite) | 4 | Correctly gets ன் → ற் (திரிதல்) and the dropped ம் in மரம், but contradicts itself and states a false உடம்படுமெய் 'ய்' rule, calling ர and வே vowels. Broken formula formatting; capped at 4. | [r3-gemini.txt](answers/r3-gemini.txt) |
| Qwen 3.5 4B (Ollama, CPU) | 1 | Invents a non-existent 'ஆந்த' rule, splits wrongly (பொன் + குட, மர + வேர்) and produces nonsense like பொன்னுக்குடம். Rambled until it was cut off. | [r3-qwen35-4b.txt](answers/r3-qwen35-4b.txt) |
| Gemma 4 E4B (Ollama, CPU) | 3 | Both splits are correct, but it calls பொற்குடம் a 'மிகுதல்' case with made-up terms and labels மரவேர் 'ஒட்டுநிலை', missing that ம் drops. | [r3-gemma4-e4b.txt](answers/r3-gemma4-e4b.txt) |
| Nemotron 3.5 Bolt E4B (Ollama, CPU) | 2 | Splits correctly but confidently says both are விகாரமற்ற புணர்ச்சி with no change at all, which is wrong for both; also mislabels ன் as 'உயிர்மெய் வல்லினம்'. | [r3-nemotron-35-bolt-e4b.txt](answers/r3-nemotron-35-bolt-e4b.txt) |

### Round 4: Slang to English

```
இந்த இரண்டு வரிகளையும் இயல்பான ஆங்கிலத்தில் மொழிபெயர்த்து, அர்த்தத்தையும் சொல்லுங்கள்:
1) (மதுரை) "என்னப்பா, இம்புட்டு நேரமா? வெரசா வா, பஸ்ஸு போயிரும்!"
2) (சென்னை) "இன்னா மச்சி, மெர்சல் ஆயிட்டியா? சும்மா கலாய்ச்சேன் டா."
```

| AI | Score | Judge's reason | Answer |
|---|---|---|---|
| ChatGPT (free model) | 10 | Both translations sound like real English ('Did I freak you out? I was just messing with you'), every slang word is glossed correctly, plus a useful tone comparison. | [r4-chatgpt.txt](answers/r4-chatgpt.txt) |
| Gemini (free model, Flash-Lite) | 9 | Accurate, natural English for both lines with correct glosses for வெரசா, மெர்சல் and கலாய். Only the alternate 'triggered' slightly misses the nuance. | [r4-gemini.txt](answers/r4-gemini.txt) |
| Qwen 3.5 4B (Ollama, CPU) | 1 | Translates line 1 as 'we should take the bus' and line 2 as 'you've missed the bus'; இம்புட்டு and மெர்சல் are explained with nonsense. | [r4-qwen35-4b.txt](answers/r4-qwen35-4b.txt) |
| Gemma 4 E4B (Ollama, CPU) | 3 | Line 1 is excellent. Line 2 invents a meaning for மெர்சல் ('did you totally fail / get busted'), and a stray 'ramach' token appears; capped. | [r4-gemma4-e4b.txt](answers/r4-gemma4-e4b.txt) |
| Nemotron 3.5 Bolt E4B (Ollama, CPU) | 4 | Line 1 is close ('is it this late?'). Line 2 offers 'melted' and explains மெர்சல் as getting very angry or over-emotional, which is wrong; capped at 4. | [r4-nemotron-35-bolt-e4b.txt](answers/r4-nemotron-35-bolt-e4b.txt) |

### Round 5: Tech help

```
இதை அம்மா அப்பாவுக்குப் புரியும்படி இயல்பான, எளிய தமிழில் மொழிபெயர்க்கவும்:
"Your phone is running out of storage. Delete old WhatsApp videos and turn on cloud backup so you don't lose your photos."
```

| AI | Score | Judge's reason | Answer |
|---|---|---|---|
| ChatGPT (free model) | 7 | Faithful and easy to follow, and explains cloud backup simply instead of coining a word. Reads like formal written Tamil rather than how you would talk to parents. | [r5-chatgpt.txt](answers/r5-chatgpt.txt) |
| Gemini (free model, Flash-Lite) | 9 | Correct, warm spoken Tamil with familiar loanwords (போன், டெலிட், ஆன் பண்ணு), plus an even simpler second version. Tiny oddity: 'போயிப்பிடாம'. | [r5-gemini.txt](answers/r5-gemini.txt) |
| Qwen 3.5 4B (Ollama, CPU) | 1 | Contains a broken word (பonselின்) and nonsense like 'வாட்ஸ்அப் சமன்கள்... டாப் செய்யப்பட்டால்'; the delete-old-WhatsApp-videos instruction is lost. | [r5-qwen35-4b.txt](answers/r5-qwen35-4b.txt) |
| Gemma 4 E4B (Ollama, CPU) | 6 | Version 3 is natural, but version 1 uses the stiff coined word மேகக் கோப்பு and version 2 drops the German word 'Speicher' mid-sentence. | [r5-gemma4-e4b.txt](answers/r5-gemma4-e4b.txt) |
| Nemotron 3.5 Bolt E4B (Ollama, CPU) | 8 | Natural spoken Tamil addressed to Amma/Appa with a handy summary. A Vietnamese word 'chỗ' slips into the explanation note. | [r5-nemotron-35-bolt-e4b.txt](answers/r5-nemotron-35-bolt-e4b.txt) |

### Round 6: Short story

```
தீபாவளிக்கு முந்தைய இரவு பற்றி, 80 சொற்களுக்குள் ஒரு சின்ன தமிழ்க் கதை எழுதுங்கள். கடைசியில் ஒரு சின்ன திருப்பம் இருக்க வேண்டும்.
```

| AI | Score | Judge's reason | Answer |
|---|---|---|---|
| ChatGPT (free model) | 7 | About 50 words, correct Tamil, and an emotional twist that plays on the girl's name நிலா (moon). The setup is a little muddled about who knocked and left the gifts. | [r6-chatgpt.txt](answers/r6-chatgpt.txt) |
| Gemini (free model, Flash-Lite) | 6 | About 70 words with a genuine twist (grandma's jasmine and letter in the cracker box). Spelling slips (இமட்டாமல், தலைக்கீழாக) and a muddled letter line cost points. | [r6-gemini.txt](answers/r6-gemini.txt) |
| Qwen 3.5 4B (Ollama, CPU) | 1 | Mostly nonsense sentences ('வெளிநாட்டில் புத்தகங்கள் மட்டுமே எரிந்தது', 'திருவிக்க') with no clear plot or twist. | [r6-qwen35-4b.txt](answers/r6-qwen35-4b.txt) |
| Gemma 4 E4B (Ollama, CPU) | 3 | Readable but with odd images (cracker powder sprinkled on houses, a bright moon on new-moon Diwali eve), and the ending is just a deflated balloon, not a twist. | [r6-gemma4-e4b.txt](answers/r6-gemma4-e4b.txt) |
| Nemotron 3.5 Bolt E4B (Ollama, CPU) | 4 | Short, correct Diwali-eve scene, but the 'twist' (his hand puppet vanished when the crackers burst) is unclear and has no payoff. | [r6-nemotron-35-bolt-e4b.txt](answers/r6-nemotron-35-bolt-e4b.txt) |

