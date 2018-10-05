FROM debian:stretch

# Install latest stable LibreOffice
RUN apt-get update -qq && apt-get install -y poppler-utils poppler-data ghostscript tesseract-ocr pdftk libreoffice xvfb libreoffice-l10n-zh-cn xfonts-wqy ttf-wqy-zenhei ttf-wqy-microhei libreoffice libreoffice-gnome --no-install-recommends --fix-missing && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apt/archives/*.deb /var/cache/apt/*cache.bin

COPY fonts/simsun.ttc /usr/share/fonts/
RUN chmod 644 /usr/share/fonts/simsun.ttc && mkfontscale && mkfontscale && fc-cache -fsv
RUN useradd --create-home --shell /bin/bash converter && chown converter:converter /usr/bin/libreoffice
USER converter
WORKDIR /home/converter
RUN mkfontscale && mkfontscale && fc-cache -fsv
COPY tools/shell2http /home/converter/

CMD /home/converter/shell2http -form \
    GET:/form 'echo "<html><body><form method=POST action=/file enctype=multipart/form-data><input type=file name=uplfile><input type=submit></form>"' \
    POST:/file 'cat $filepath_uplfile > uploaded_file && libreoffice --invisible --headless --nologo --convert-to pdf --outdir $(pwd) uploaded_file && cat uploaded_file.pdf && rm -f uploaded_file uploaded_file.pdf'
