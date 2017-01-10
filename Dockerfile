FROM centos:6
ADD Recipe /Recipe
ADD bundle /bundle
#RUN bash -ex Recipe && yum clean all && rm -rf /out  && rm -rf HighFidelity*
#RUN bash -ex Recipe && yum clean all && rm -rf /out
RUN bash -ex Recipe && yum clean all 
