# Nautilus Scripts

There is a lot of nautilus scripts all over the web.
But a lot of these scripts are not working very well.
No check for errors and no check for dependencies.
Some of them only work in nautilus, some others only in nemo.
Some of them only work with files that not contained spaces, and so on.
So I decided to write my own scripts, that has the following advantages:

-   It runs the processes in parallel: processes multiple files at same time;
-   It is easy to copy and adapt the scripts for other purposes;
-   It has status notifications (dependency errors, supported mime-type);
-   It works in any file manager: no use of the variable \$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS or NEMO equivalent;
-   It has an direct usage, without an input box to ask parameters;
-   It never overwrites the input file. The output is different of the input;
-   All shell scripts were checked by [shellcheck](https://github.com/koalaman/shellcheck).

## Getting Started

### Installing in nautilus file manager

```bash
git clone https://github.com/AhmedMohamedAbdelaty/nautilus-scripts ~/.local/share/nautilus/scripts
```

### Installing in nemo file manager

```bash
git clone https://github.com/AhmedMohamedAbdelaty/nautilus-scripts ~/.local/share/nemo/scripts
```

### Installing in caja file manager

```bash
git clone https://github.com/AhmedMohamedAbdelaty/nautilus-scripts ~/.config/caja/scripts
```

---

## What I Added

### some scripts are not mine and  i used chat gpt and other chatbots to create them
---

i added my scripts to `ahmed` folder (will be changed later) :

-   all folder word-excel-to pdf

    convert folder of word or excel or powerpoint to pdf

-   aud-to-vid-image-best

    convert audio to video with selected image

-   audio to video

    convert audio to video with the thumbnail image of the audio

-   compine-pdf

    compine pdf files to one pdf file

-   cut-duration

    cut video or audio with start time and duration time

-   cut dur multiple starts

    cut video or audio with multiple start times and same duration time

-   cut_segment

    cut video into parts with the same duration time

-   img-pdf-combine

    convert folder of images to pdf file and combine pdf files to one pdf file

-   pdfA_converter

    convert folder of pdf files to pdfA format files (fixex some fonts problems)

-   speed up video or audio

        speed up video or audio with selected speed

-   video to gif

    convert video to gif

---

## Contributing

If you spot a bug, or want to improve the code, or even make the content better, you can do the following:

-   [Open an issue](https://github.com/AhmedMohamedAbdelaty/nautilus-scripts/issues/new)
    describing the bug or feature idea;
-   Fork the project, make changes, and submit a pull request.
