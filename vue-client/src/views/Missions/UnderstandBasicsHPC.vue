<template>
  <div class="text-center text-3xl">Introduction to HPC</div>
  <Accordion :value="['0']" multiple>
    <AccordionPanel value="0">
      <AccordionHeader>What is HPC?</AccordionHeader>
      <AccordionContent>
        <ul>
          <li>Definition of HPC</li>
          <li>Application of HPC</li>
          <li>What it takes to make HPC</li>
          <li>Top level overview of nodes</li>
        </ul>
      </AccordionContent>
    </AccordionPanel>
    <AccordionPanel value="1">
      <AccordionHeader>HPC System Components</AccordionHeader>
      <AccordionContent>
        <ul>
          <li>Each components described</li>
          <li>How GPUs are interconnected</li>
          <li>Storage systems</li>
          <li>Filesystems and introduction of parallel file systems</li>
        </ul>
        <div class="text-xl pt-10">Answer this question!!!</div>
        <div class="grid gap-4">
          <div class="flex items-center gap-2">
            <RadioButton inputId="answer1" name="question" value="Answer 1" />
            <label for="answer1">Answer 1</label>
          </div>
          <div class="flex items-center gap-2">
            <RadioButton inputId="answer2" name="question" value="Answer 2" />
            <label for="answer2">Answer 2</label>
          </div>
          <div class="flex items-center gap-2">
            <RadioButton inputId="answer3" name="question" value="Answer 3" />
            <label for="answer3">Answer 3</label>
          </div>
          <div class="flex items-center gap-2">
            <RadioButton inputId="answer4" name="question" value="Answer 4" />
            <label for="answer4">Answer 4</label>
          </div>
        </div>
      </AccordionContent>
    </AccordionPanel>
  </Accordion>

  <Fieldset legend="Note!">
    <p class="m-0">
      This is a section for including any note to warn/provide note to user.
    </p>
  </Fieldset>
</template>
<script setup></script>
