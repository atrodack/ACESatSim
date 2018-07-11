star_vec = 1:2;
filter_vec = 1:5;
outputdir = 'E:/cygwin64/home/Alex/Documents/example1';


for STAR = star_vec
    for BANDNO = filter_vec
        acend_main(STAR,BANDNO,outputdir);
    end
end