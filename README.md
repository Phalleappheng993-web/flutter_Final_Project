# Imagine AI — Flutter UI

កម្មវិធីនេះរៀបចំ UI តាមគំរូ Figma ដែលបានផ្តល់។

## អេក្រង់ និង flow

- **Intro 1–3**: បង្ហាញគោលបំណងកម្មវិធី និងជំហានប្រើប្រាស់; Skip ឬ Get started ទៅ Login។
- **Log in / Sign up / Forgot password**: ទម្រង់ចូលប្រើ និងបង្កើតគណនីសាកល្បង។
- **Create**: សរសេរ prompt, បើក/បិទ AI prompt improvement និងជ្រើស Realistic, Anime, Watercolor ឬ 3D។ Generate ទៅទំព័រ Result។
- **Generating / Busy error / Result / Image details**: មានទំព័ររៀងៗខ្លួន; Result មាន prompt, style, Save, Download, Share និង Details។ Busy error អាចមើលពី Help and support។
- **Explore / Library**: ស្វែងរក sample idea និងមើល prompt history ក្នុង session។
- **Profile / Edit profile / Appearance / Change email / Change password / Help and support / Forgot password**: ជាទំព័រដាច់ដោយឡែក និងមាន navigation តាម profile ឬ Login។

## Folder `lib/repair/`

- `app.dart` — theme និង onboarding/auth flow។
- `models/artwork.dart` — ទិន្នន័យសម្រាប់រូបភាព។
- `screens/home_screen.dart` — Create, Explore, Library, Profile និង Result។
- `widgets/sample_artwork.dart` — រូបគំរូ local សម្រាប់ preview។
- `services/` — ទីតាំងសម្រាប់ភ្ជាប់ image model និង prompt improvement API។

## ចំណាំអំពី AI និងការរក្សាទុក

Project មិនទាន់មាន backend ឬ API key សម្រាប់ image model ទេ។ Generate បច្ចុប្បន្នបង្ហាញ sample illustration ក្នុង Flutter ហើយ prompt history រក្សាទុកតែក្នុង session។ Improve with AI បន្ថែមឃ្លាលើ prompt ក្នុងមូលដ្ឋាន។ Save/Share ជា UI demo មិនទាន់រក្សាទុក file ឬបើក share sheet ពិត។ ភ្ជាប់ backend ក្នុង `lib/repair/services/` ដើម្បីជំនួស demo។ កុំដាក់ private API key ក្នុង mobile app។

## របៀបសរសេរ prompt

Prompt ខ្លីដូចជា `a fox in a library` កំណត់តែប្រធានបទ។ បន្ថែមសកម្មភាព និងទីតាំង ដូចជា `a red fox reading a book in a cozy library` ធ្វើឲ្យសាច់រឿងច្បាស់។ បន្ថែម `warm lamp light, soft shadows` កំណត់ពន្លឺ និងអារម្មណ៍។ ពាក្យ `watercolor` ផ្ដល់ពណ៌រាល និងគែមទន់ ខណៈ `cinematic lighting` បន្ថែម contrast។ រចនាប័ទ្ម និងពាក្យជាក់លាក់ជួយណែនាំរូបភាពដែល model បង្កើត។
