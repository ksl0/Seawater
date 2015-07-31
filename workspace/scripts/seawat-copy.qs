#$ -N hom2D
#$ -t 3-4
# Template:  Basic Serial Job
# Revision:  $Id: serial.qs 523 2014-09-16 14:29:54Z frey $
#
# Change the following to #$ and set the amount of memory you need
# per-slot if you're getting out-of-memory errors using the
# default:
#$ -l m_mem_free=3G
#
# If you want an email message to be sent to you when your job ultimately
# finishes, edit the -M line to have your email address and change the
# next two lines to start with #$ instead of just #
# -m eas
# -M my_address@mail.server.com
#

# Add vpkg_require commands after this line:
vpkg_require gcc/4.8
DIR=/lustre/scratch/calhoun/$JOB_NAME$SGE_TASK_ID
PATH=/home/work/hmichael/sw/bin:$PATH

# Now append all of your shell commands necessary to run your program
# after this line:

if [ -f $DIR/run3.nam ]; then
  cd $DIR
  swt_v4 run3.nam
  date "+ Stop date and time: %Y/%m/%d %T"
  lrm *.p00 *.rpt *.bf *.adv *.mto *.bas *.btn *.cnf *.dis 
  lrm *.dsp *.ftl *.gcg *.lmt *.lpf *.nam *.oc *.pcg *.ssm
  lrm *.vdf SEAWAT.BAT
fi
